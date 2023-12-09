import dotenv from "dotenv";
dotenv.config();
import os from "os";
import fs from "fs";

import express from "express";
import { minioClient } from "./s3stream";
import multer, { diskStorage, memoryStorage } from "multer";
import { ItemBucketMetadata } from "minio";
import path from "path";
import { FileUploader } from "./FileUploader";
import { start } from "repl";

fs.mkdirSync(os.tmpdir() + "/uploads/", { recursive: true });

// start expressjs
const app = express();
const videoUploads = multer({
  // Upload file to the temporal folders
  // storage: diskStorage({ destination: '/tmp/uploads' }),
  storage: memoryStorage(),
  limits: { fileSize: 1024 * 1024 * 128 },
});
const bucketName = process.env.S3_BUCKET || "minio_media_test";

app.use(function (req, res, next) {
  // Website you wish to allow to connect
  res.setHeader("Access-Control-Allow-Origin", "*");

  // Request methods you wish to allow
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, OPTIONS, PUT, PATCH, DELETE"
  );

  // Request headers you wish to allow
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-Requested-With,content-type"
  );

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions)
  res.setHeader("Access-Control-Allow-Credentials", "true");

  // Pass to next layer of middleware
  next();
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "../public/index.html"));
});

// API to get all availables file on S3 bucket
app.get("/video", async (_, res) => {
  const bucketStream = minioClient.extensions.listObjectsV2WithMetadata(
    bucketName,
    "",
    false
  );
  const filelist: { fileName: string }[] = [];
  bucketStream.on("data", (obj) => {
    const metadata = obj.metadata! as ItemBucketMetadata;
    filelist.push({
      // filePathName: obj.name!,
      fileName: metadata.filename,
    });
  });
  bucketStream.on("end", function () {
    res.status(200).send({ fileList: filelist });
  });
  bucketStream.on("error", function (err) {
    res.status(500).send(err);
  });
});

function getRangeBytes(rangeHeader?: string): [number, number] {
  if (!rangeHeader) return [NaN, NaN];
  const parts = rangeHeader.split("=");
  if (parts[0] === "bytes" && parts[1]) {
    const rangeParts = parts[1].split("-");
    return [parseInt(rangeParts[0]), parseInt(rangeParts[1])];
  }
  return [NaN, NaN];
}

app.get("/video/:filename", async (req, res) => {
  try {
    // console.log(`header: ${JSON.stringify(req.headers)}`);
    let [startRange, endRange] = getRangeBytes(req.headers["range"]);
    res.setHeader("Accept-Ranges", "bytes");
    // res.setHeader("Range", "bytes=0-1000");
    // if (range[0] === null) {
    //   res.status(400).send("Invalid range");
    //   return;
    // }

    const defaultChunkSize = 1024 * 256;
    const fileName = req.params.filename;
    const fileMetadata = await minioClient.statObject(bucketName, fileName);
    const fileSize = fileMetadata.size;
    // console.log(`before: ${JSON.stringify(range)}`);
    // let startRange = range[0];
    // let endRange = range[1];
    if (!isNaN(startRange) && isNaN(endRange)) {
      endRange = startRange + defaultChunkSize;
      endRange = Math.min(endRange, fileMetadata.size);
    } else if (isNaN(startRange) && !isNaN(endRange)) {
      startRange = endRange - defaultChunkSize;
      startRange = Math.max(startRange, 0);
    }

    if (startRange >= fileMetadata.size || endRange > fileMetadata.size) {
      res.writeHead(416, {
        "content-range": `bytes */${fileMetadata.size}`,
      });
      return res.end();
    }

    const rangeLength = endRange - startRange;
    // console.log(`range: ${startRange} ${endRange - 1}`);
    // res.setHeader("Content-Range", `bytes ${startRange}-${endRange}/${fileMetadata.size}`);
    // res.setHeader("Content-Length", `${rangeLength}`);
    // res.setHeader("Content-Type", "video/mp4");
    // res.status(206);
    res.writeHead(206, {
      "Content-Range": `bytes ${startRange}-${endRange - 1}/${
        fileMetadata.size
      }`,
      "Content-Length": rangeLength,
      "Content-Type": "video/mp4",
    });

    const objectStream = await minioClient.getPartialObject(
      bucketName,
      fileName,
      startRange,
      rangeLength
    );
    objectStream.pipe(res);
  } catch (e) {
    res.status(500).send(e);
  }
});

const fileUploaders: Record<string, FileUploader> = {};
// API to create the stream for a file by path
app.post("/video", videoUploads.single("file"), async (req, res) => {
  if (!req.file) {
    res.status(400).send("No file uploaded.");
    return;
  }
  const totalChunks = Number(req.body.chunkCount);
  const chunkIndex = Number(req.body.chunkIndex);
  const chunkSize = Number(req.body.chunkSize);
  const fileOriginalName = req.body.filename;
  const mimeType = req.file.mimetype;

  if (!totalChunks || !chunkSize || !fileOriginalName) {
    res.status(400).send("Missing required parameters.");
    return;
  }

  let fileUploader = fileUploaders[fileOriginalName];

  if (!fileUploader) {
    const filePath = `${os.tmpdir()}/uploads/${fileOriginalName}`;
    console.log(`filePath, ${filePath}`);
    fileUploader = new FileUploader(
      fileOriginalName,
      mimeType,
      filePath,
      totalChunks,
      chunkSize
    );
    fileUploaders[fileOriginalName] = fileUploader;

    fileUploader.once("allChunksWritten", async () => {
      delete fileUploaders[fileOriginalName];

      const fileMetadata: ItemBucketMetadata = {
        filename: fileUploader.originalFileName,
        mimeType: fileUploader.mimeType,
      };

      console.log(
        `Uploading file ${fileUploader.filePath} ${JSON.stringify(
          fileMetadata
        )} to bucket ${bucketName}/${fileOriginalName}`
      );
      // Write file to s3
      // Then delete the file
      await minioClient.fPutObject(
        bucketName,
        fileOriginalName,
        fileUploader.filePath,
        fileMetadata
      );
      fs.unlinkSync(fileUploader.filePath);
    });
  }

  // Write the chuni
  const { allChunksWritten } = fileUploader.writeChunk(
    chunkIndex,
    req.file.buffer,
    req.file.size
  );
  if (allChunksWritten) {
    res.status(201).send("File uploaded successfully.");
  } else {
    res.status(200).send("Chunk uploaded successfully.");
  }
});

const httpPort = process.env.HTTP_PORT;
app.listen(httpPort, () => {
  console.log(`Server started on http://localhost:${httpPort}/`);
});
