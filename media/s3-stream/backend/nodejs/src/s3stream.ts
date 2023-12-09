import { Client } from "minio";
import fs from "fs";

export const minioClient = new Client({
  endPoint: process.env.S3_ENDPOINT || '',
  port: process.env.S3_PORT ? Number(process.env.S3_PORT) : 9000,
  useSSL: false,
  accessKey: process.env.S3_ACCESS_KEY || '',
  secretKey: process.env.S3_SECRET_KEY || '',
});

// Write chunk to temporal folder
export async function writeChunkToTempFile(writeMyStream: fs.WriteStream, chunk: any, chunkIndex: number) {
  // writeMyStream.write
  // const writeMyStream = fs.createWriteStream(__dirname+'/APPENDED.webm', {flags:'a', encoding:null});

  // Write chunk to temporal folder
  // fs.writeFileSync(`/tmp/uploads/${chunkIndex}`, chunk, {});
  // fs.writeFileSync()
}

// Merge all chunks into a single file
// Upload the file to S3

// create S3 Stream for the file
// export async function createS3Stream(s3Bucket: string, objectPath: string): Promise<Readable> {
//   const objectStat = await minioClient.statObject(s3Bucket, objectPath);

//   return new S3Stream(minioClient, s3Bucket, objectPath, 1024 * 1024 * 5, objectStat.size);
// }

// // Upload the S3 stream
// export async function uploadFileToS3(
//   s3Bucket: string,
//   objectPath: string,
//   file: any
// ) {
//   const fileMetadata: Minio.ItemBucketMetadata = {};
//   minioClient.fPutObject(
//     s3Bucket,
//     objectPath,
//     file,
//     fileMetadata,
//     function (err, etag) {
//       if (err) return console.log(err);
//       console.log("File uploaded successfully.");
//     }
//   );
// }

// class S3Stream {
//   _client: Minio.Client;
//   // Current read index
//   // chunk size
//   _chunkSize: number;

//   // file size
//   _fileSize: number;

//   _offset: number;

//   _s3Bucket: string;
//   _objectPath: string;

//   constructor(client: Minio.Client, s3Bucket: string, objectPath: string, chunkSize: number, fileSize: number) {
//     this._client = client;
//     this._chunkSize = chunkSize;
//     this._fileSize = fileSize;
//     this._offset = 0;
//     this._s3Bucket = s3Bucket;
//     this._objectPath = objectPath;
//   }

//   async adjustOffset(offset: number) {
//     this._offset = offset;

//     if (this._offset < 0) {
//       this._offset = 0;
//     }

//     const validMaxOffset = this._fileSize - 1;
//     if (this._offset > validMaxOffset) {
//       this._offset = validMaxOffset;
//     }
//   }

//   async readChunk(): Promise<Readable | null> {
//     if (this._offset >= this._fileSize) {
//       return null;
//     }

//     const currentOffset = this._offset;
//     let readLength = this._chunkSize;
//     let newOffset = this._offset + readLength;
//     if (newOffset >= this._fileSize) {
//       readLength = this._fileSize - this._offset;
//     }
//     this._offset += readLength;
//     // Create the chunk, if there's data, push it to the stream
//     const dataStream = await minioClient.getPartialObject(this._s3Bucket, this._objectPath, currentOffset, readLength);
//     return dataStream;
//   }
// }

// export class S3DownloadTransformStream extends Stream.Transform {
//   _transform(
//     chunk: any,
//     encoding: BufferEncoding,
//     callback: TransformCallback
//   ): void {}
//   _flush(callback: TransformCallback): void {}
// }

// export class S3DownloadReadableStream extends Stream.Readable {
//   protected s3Stream: S3Stream;
//   constructor(client: Minio.Client, s3Bucket: string, objectPath: string, chunkSize: number, fileSize: number) {
//     super();
//     this.s3Stream = new S3Stream(client, s3Bucket, objectPath, chunkSize, fileSize);
//   }

//   _read(size: number): void {
//     this.s3Stream.readChunk().then((chunk) => {
//       // End of file
//       if (!chunk) {
//         this.push(null);
//         return;
//       }

//       chunk.on("readable", () => {
//         let data;
//         while (null != (data = chunk.read())) {
//           this.push(data);
//         }
//       });
//     });
//   }
// }
