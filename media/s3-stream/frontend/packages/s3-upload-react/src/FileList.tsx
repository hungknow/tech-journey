import React, { useState } from "react";

interface FileContent {
  fileName: string;
}

export interface FileListProps {
  onItemClick: (fileName: string) => void;
}
export const FileList: React.FC<FileListProps> = ({ onItemClick }) => {
  const [fileList, setFileList] = useState<FileContent[]>([]);
  const fetchFiles = async () => {
    const data = await fetch(`${process.env.SERVER_URL}/video`, {
      method: "GET",
    });
    const dataJson = await data.json();
    const fileList = dataJson.fileList;
    setFileList(fileList);
  };

  React.useEffect(() => {
    fetchFiles();
  }, []);
  return (
    <>
      {fileList.map((file) => {
        return (
          <div>
            <a
              href=""
              onClick={(e) => {
                e.preventDefault();
                onItemClick && onItemClick(file.fileName);
              }}
            >
              {file.fileName}
            </a>
          </div>
        );
      })}
    </>
  );
};
