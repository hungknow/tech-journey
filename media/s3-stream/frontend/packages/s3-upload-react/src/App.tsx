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
          <source src="/video" type="video/mp4" />
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
