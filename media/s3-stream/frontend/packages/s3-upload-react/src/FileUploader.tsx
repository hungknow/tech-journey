import React, { ChangeEvent, FormEventHandler } from "react";

const fileChunkSize = 1024 * 1024 * 5; // 5MB

export const FileUploader: React.FC = () => {
  const uploadFile = async (file: File) => {
    let chunkIndex = 0;
    let chunkCounts = Math.ceil(file.size / fileChunkSize);

    for (let i = 0; i < chunkCounts; i++) {
      const chunkByteIndex = chunkIndex * fileChunkSize;
      const fileChunk = file.slice(
        chunkByteIndex,
        chunkByteIndex + fileChunkSize
      );
      const formData = new FormData();
      formData.append("chunkSize", fileChunk.size.toString());
      formData.append("chunkIndex", chunkIndex.toString());
      formData.append("chunkCount", chunkCounts.toString());
      formData.append("file", fileChunk);

      await fetch("/video", {
        method: "POST",
        body: formData,
      });
    }
  };

  const fileSubmit = async (e: ChangeEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!e.target.files) {
      console.error("There's no file to upload");
      return;
    }

    // try to upload each file
    for (const file of e.target.files) {
      await uploadFile(file);
    }
  };

  return (
    <form
      action="/video"
      method="post"
      encType="multipart/form-data"
      onSubmit={fileSubmit}
    >
      <div className="input-group">
        <label htmlFor="files">Select a file</label>
        <input id="file" type="file" accept="video/mp4" multiple />
      </div>
      <input type="submit" name="submit" value="Upload" />
    </form>
  );
};
