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

app.get("/video/:filename", async (req, res) => {
  const fileName = req.params.filename;
  const objectStream = await minioClient.getObject(bucketName, fileName);
  objectStream.pipe(res);
});

const fileUploaders: Record<string, FileUploader> = {};
// API to create the stream for a file by path
app.post("/video", videoUploads.single("file"), async (req, res) => {
  if (!req.file) {
    res.status(400).send("No file uploaded.");
    return;
  }
  const totalChunks = req.body.chunkCount;
  const chunkIndex = req.body.chunkIndex;
  const chunkSize = req.body.chunkSize;
  const fileOriginalName = req.body.filename;
  const mimeType = req.file.mimetype;

  if (!totalChunks || !chunkIndex || !chunkSize || !fileOriginalName) {
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
