import fs from "fs";

function shuffle(arr: number[]) {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i - 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
}

function writeToFileRandomLocation(filePath: string, maxLineCount: number) {
  const fixedLineLength = 10;
  const file = fs.openSync(filePath, "w");
  const fileMaxLength = fixedLineLength * maxLineCount;

  let offsetRandom = [];
  for (let i = 0; i < maxLineCount; i++) {
    offsetRandom.push(i);
  }
shuffle(offsetRandom);
  let count = 0;
  for (const offset of offsetRandom) {
    let line = `${offset}`;
    line = line.padEnd(fixedLineLength - 2, " ");
    line = line.concat("|\n");
    console.log(`Writing line ${line.length} at offset ${offset}`);
    fs.writeSync(
      file,
      Buffer.from(line),
      0,
      line.length,
      offset * fixedLineLength
    );
    // if (++count >= 2) {
    //   break;
    // }
  }

  //   const buffer = Buffer.alloc(chunkSize);
  //   fs.writeSync(file, buffer, 0, chunkSize, randomOffset);
  fs.closeSync(file);
}

writeToFileRandomLocation("/tmp/randomfile", 64);
