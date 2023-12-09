import React, { FormEvent, useRef } from "react";

const fileChunkSize = 1024 * 1024 * 1; // 5MB

export const FileUploader: React.FC = () => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const uploadFile = async (file: File) => {
    let chunkCounts = Math.ceil(file.size / fileChunkSize);

    for (let chunkIndex = 0; chunkIndex < chunkCounts; chunkIndex++) {
      const chunkByteIndex = chunkIndex * fileChunkSize;
      const fileChunk = file.slice(
        chunkByteIndex,
        chunkByteIndex + fileChunkSize
      );
      const formData = new FormData();
      formData.append("filename", file.name);
      formData.append("chunkSize", fileChunk.size.toString());
      formData.append("chunkIndex", chunkIndex.toString());
      formData.append("chunkCount", chunkCounts.toString());
      formData.append("file", fileChunk);

      await fetch(`${process.env.SERVER_URL}/video`, {
        method: "POST",
        body: formData,
      });
    }
  };

  const fileSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const files = fileInputRef.current?.files;
    // fileInputRef.current.tar
    if (!files) {
      console.error("There's no file to upload");
      return;
    }

    // try to upload each file
    for (const file of files) {
      await uploadFile(file);
    }
  };

  return (
    <form
      action={`${process.env.SERVER_URL}/video`}
      method="post"
      encType="multipart/form-data"
      onSubmit={fileSubmit}
    >
      <div className="input-group">
        <label htmlFor="files">Select video files: </label>
        <input
          ref={fileInputRef}
          id="file"
          type="file"
          accept="video/mp4"
          multiple
        />
      </div>
      <input type="submit" name="submit" value="Upload" />
    </form>
  );
};
