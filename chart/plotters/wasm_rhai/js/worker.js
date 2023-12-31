import { wasmImport } from "./wasm_loader.js";

const playgroundPromise = wasmImport.then(wasm => wasm.Playground.new());
let offscreenCanvas = null;

async function runScript(script) {
    const playground = await playgroundPromise;
    function output(line) {
        self.postMessage({
            req: "runScript/output",
            output: line,
        })
    }
    try {
        playground.set_offscreen_canvas(offscreenCanvas);
        let result = playground.run_script(script, s => {
            output(`[PRINT] ${s}`);
        }, s => {
            output(`[DEBUG] ${s}`);
        }, ops => {
            self.postMessage({
                req: "runScript/updateOps",
                ops,
            });
        });
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
    } else if (ev.data.req === "setOffScreenCanvas") {
        offscreenCanvas = ev.data.canvas    
        // playground.set_offscreen_canvas(offscreenCanvas);
    }else {
        console.log("Unknown message received by worker:", ev.data);
    }
}

wasmImport.then(() => {
    self.postMessage({ req: "_ready" });
});