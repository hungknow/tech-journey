import dotenv from "dotenv";
dotenv.config();

import express from "express";
import { minioClient } from "./s3stream";
import multer, { diskStorage } from "multer";
import { ItemBucketMetadata } from "minio";
import path from "path";
import { FileUploader } from "./FileUploader";

// start expressjs
const app = express();
const videoUploads = multer({ 
  // Upload file to the temporal folders
  storage: diskStorage({ destination: '/tmp/uploads' }), 
  limits: { fileSize: 1024 * 1024 * 128 } 
});
const bucketName = process.env.S3_BUCKET || "minio_media_test";

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, "../public/index.html"));
});

// API to upload the file to S3 bucket
app.get("/video", async (_, res) => {
  const objectStream = await minioClient.getObject(bucketName, "file_example_MP4_480_1_5MG.mp4");
  // // const stream = await createS3Stream('test', 'test.mp4')
  objectStream.pipe(res);
  // res.status(400)
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
  const fileOriginalName = req.file.originalname;
  const mimeType = req.file.mimetype;

  if (!totalChunks || !chunkIndex || !chunkSize) {
    res.status(400).send("Missing required parameters.");
    return;
  }

  let fileUploader = fileUploaders[fileOriginalName];

  if (!fileUploader) {
    fileUploader = new FileUploader(fileOriginalName, mimeType, req.file.filename, totalChunks, chunkSize);
    fileUploaders[fileOriginalName] = fileUploader;

    fileUploader.once("allChunksWritten", async () => {
      delete fileUploaders[fileOriginalName];;

        const fileMetadata: ItemBucketMetadata = {
          filename: fileUploader.originalFileName,
          mimeType: fileUploader.mimeType,
        };
  
      // Write file to s3
      // Then delete the file
      await minioClient.fPutObject(bucketName, fileOriginalName, fileUploader.filePath, fileMetadata);
    });
  }

  // Write the chuni
  const { allChunksWritten } = fileUploader.writeChunk(chunkIndex, req.file.buffer, req.file.size);
  if (allChunksWritten) {
    res.status(201).send("File uploaded successfully.");
  } else {
    res.status(200).send("Chunk uploaded successfully.");
  }


  // const objectName = req.file.originalname;
  // console.log(`Uploading file ${JSON.stringify(fileMetadata)} to bucket ${bucketName}/${objectName}`);
  // minioClient.putObject(
  //   bucketName,
  //   objectName,
  //   req.file.buffer,
  //   req.file.size,
  //   fileMetadata,
  //   function (err) {
  //     if (err) {
  //       res.status(500).send(err);
  //       return;
  //     }
  //     res.status(200).send("File uploaded successfully.");
  //   }
  // );
});

// API to get all availables file on S3 bucket

const httpPort = process.env.HTTP_PORT;
app.listen(httpPort, () => {
  console.log(`Server started on http://localhost:${httpPort}/`);
});
