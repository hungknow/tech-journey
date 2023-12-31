import * as fs from "fs";
import { EventEmitter } from "events";

export class FileUploader extends EventEmitter {
  protected fileFd: number;
  protected writtenChunks: Record<number, boolean> = {};
  protected writtenChunkCount = 0;
  constructor(
    public originalFileName: string,
    public mimeType: string,
    public filePath: string,
    public totalChunks: number,
    public chunkSize: number
  ) {
    super();
    this.fileFd = fs.openSync(filePath, "w");
  }

  writeChunk(
    chunkIndex: number,
    chunk: NodeJS.ArrayBufferView,
    chunkLength: number
  ): { allChunksWritten: boolean } {
    if (chunkIndex >= this.totalChunks) {
      throw new Error(
        `chunkIndex ${chunkIndex} is greater than totalChunks ${this.totalChunks}`
      );
    }
    if (this.writtenChunks[chunkIndex] === true) {
      throw new Error(
        `The chunk index ${chunkIndex} was written before. ${JSON.stringify(
          this.writtenChunks
        )}`
      );
    }

    this.writtenChunks[chunkIndex] = true;
    this.writtenChunkCount++;
    fs.writeSync(
      this.fileFd,
      chunk,
      0,
      chunkLength,
      chunkIndex * this.chunkSize
    );

    let allChunksWritten = false;
    console.log(`Written chunk ${chunkIndex} ${this.writtenChunkCount} of ${this.totalChunks}`)

    if (this.writtenChunkCount == this.totalChunks) {
      allChunksWritten = true;
      fs.closeSync(this.fileFd);
      this.emit("allChunksWritten");
    }

    return {
      allChunksWritten,
    };
  }
}
