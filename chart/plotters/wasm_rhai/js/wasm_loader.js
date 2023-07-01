import wasmPath from "../pkg/index_bg.wasm";
import wasmInit, * as wasm from "../pkg";

const wasmLoadPromise = wasmInit(wasmPath)
const wasmImport = wasmLoadPromise.then(_wasmInternal => wasm);

export { wasm, wasmImport, wasmLoadPromise };