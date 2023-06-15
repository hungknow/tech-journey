async function passMemoryToJavaScript() {
    const bytesModule = await fetch("target/wasm32-unknown-unknown/debug/js_rust_shared_memory.wasm");
    const module = await bytesModule.arrayBuffer();
    const moduleInstance = await WebAssembly.instantiate(module, {});
    moduleInstance.instance.exports.memory_to_js();
    const memObj = new Uint8Array(moduleInstance.instance.exports.memory.buffer, 0).slice(0, 1);
    console.log(memObj[0]); // 13
}


async function sendMemoryFromJavaScript() {
    const bytes = await fetch("target/wasm32-unknown-unknown/debug/js_rust_shared_memory.wasm");
    const response = await bytes.arrayBuffer();
    const memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });
    const result = await WebAssembly.instantiate(response, { js: { mem: memory } });
  
    result.instance.exports.memory_to_js();
    const s = new Set([1, 2, 3]);
    let jsArr = Uint8Array.from(s);
    const len = jsArr.length;
    let wasmArrPtr = result.instance.exports.malloc(length);
    let wasmArr = new Uint8Array(result.instance.exports.memory.buffer, wasmArrPtr, len);
    wasmArr.set(jsArr);
  
    const sum = result.instance.exports.accumulate(wasmArrPtr, len);
    console.log(sum);
  
  }

passMemoryToJavaScript();
sendMemoryFromJavaScript();