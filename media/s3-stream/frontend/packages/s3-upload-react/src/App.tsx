import React, { useRef } from "react";
import { FileUploader } from "./FileUploader";
import { FileList } from "./FileList";
export const App = () => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const videoSource = useRef<HTMLSourceElement>(null);

  const changeVideoSource = (fileName: string) => {
    videoRef.current!.pause();
    videoSource.current!.src = `${process.env.SERVER_URL}/video/${fileName}`
    videoRef.current!.load();
    videoRef.current!.play();
  }
  return (
    <div>
      <main>
        <video
          ref={videoRef}
          id="videoPlayer"
          width="650"
          height="auto"
          controls
          muted
        >
          <source ref={videoSource} src={`${process.env.SERVER_URL}/video/metropole.mp4`} type="video/mp4" />
        </video>
      </main>
      <aside>
        <section id="uploadSection">
          <FileUploader />
        </section>
        <section id="fileList">
          <FileList onItemClick={(fileName) => {changeVideoSource(fileName);}} />
        </section>
      </aside>
    </div>
  );
};
