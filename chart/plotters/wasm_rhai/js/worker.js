// import * as Wasm from "plotter-wasm/index";
import { wasmImport } from "./wasm_loader.js";

const playgroundPromise = wasmImport.then(wasm => wasm.Playground.new());

async function runScript(script) {
    // const playground = Wasm.Playground.new();
    const playground = await playgroundPromise;
    function output(line) {
        self.postMessage({
            req: "runScript/output",
            output:line,
        })
    }
    try {
        let result = playground.run_script(script, s => {
            output(`[PRINT] ${s}`);
        }, s => {
            output(`[DEBUG] ${s}`);
        }, ops => {
            self.postMessage({
                req: "runScript/updateOps",
                ops,
            });
        } );
        output(`\nScript returned: "${result}"`);
    } catch (ex) {
        output(`\nEXCEPTION: ${ex}`);
    }
    postMessage({
        req: "runScript/end",
    });
}

self.onmessage = ev => {
    if (ev.data.req === "runScript") {
        runScript(ev.data.script);
    } else {
        console.log("Unknown message received by worker:", ev.data);
    }
}

// self.postMessage({ req: "_ready" });
wasmImport.then(() => {
    self.postMessage({ req: "_ready" });
});