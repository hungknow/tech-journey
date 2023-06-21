import wasmPath from "plotter-wasm/index_bg.wasm";
import wasmInit, * as wasm from "plotter-wasm";

const wasmLoadPromise = wasmInit(wasmPath)
const wasmImport = wasmLoadPromise.then(_wasmInternal => wasm);

export { wasm, wasmImport, wasmLoadPromise };