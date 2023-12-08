import dotenv from "dotenv";
dotenv.config();

import express from "express";
import { minioClient } from "./s3stream";
import multer, { memoryStorage } from "multer";
import { ItemBucketMetadata } from "minio";
import path from "path";

// start expressjs
const app = express();
const videoUploads = multer({ storage: memoryStorage(), limits: { fileSize: 1024 * 1024 * 20 } });
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

// API to create the stream for a file by path
app.post("/video", videoUploads.single("file"), async (req, res) => {
  if (!req.file) {
    res.status(400).send("No file uploaded.");
    return;
  }
  const fileMetadata: ItemBucketMetadata = {
    filename: req.file.originalname,
    filetype: req.file.mimetype,
  };
  const objectName = req.file.originalname;
  console.log(`Uploading file ${JSON.stringify(fileMetadata)} to bucket ${bucketName}/${objectName}`);
  minioClient.putObject(
    bucketName,
    objectName,
    req.file.buffer,
    req.file.size,
    fileMetadata,
    function (err) {
      if (err) {
        res.status(500).send(err);
        return;
      }
      res.status(200).send("File uploaded successfully.");
    }
  );
});

// API to get all availables file on S3 bucket

const httpPort = process.env.HTTP_PORT;
app.listen(httpPort, () => {
  console.log(`Server started on http://localhost:${httpPort}/`);
});
