import React from "react";
import { FileUploader } from "./FileUploader";
export const App = () => {
  return (
    <div>
      <main>
        <video
          id="videoPlayer"
          width="650"
          height="auto"
          controls
          muted
        >
          <source src={`${process.env.SERVER_URL}/video/file_example_MP4_480_1_5MG.mp4`} type="video/mp4" />
        </video>
      </main>
      <aside>
        <section id="uploadSection">
          <FileUploader />
        </section>
        <section id="fileList"></section>
      </aside>
    </div>
  );
};
