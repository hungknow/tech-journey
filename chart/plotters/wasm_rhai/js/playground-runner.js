import MyWorker from "workerize-loader!./worker";

let workerLoader = (function() {
    let worker = null;
    let workerPromise = null;
    let rejectWorkerLoad = null;

    function ensureWorker() {
        if (workerPromise === null) {
            workerPromise = new Promise((resolve, reject) => {
                worker = new MyWorker();
                rejectWorkerLoad = reject;
                worker.onerror = ev => {
                    workerPromise = null;
                    rejectWorkerLoad = null;
                    console.log("An error occured in the Worker then loading:", ev);
                    reject("An error occured in the worker then loading: " + ev.message);
                };
                const msgListener = ev => {
                    if (ev.data.req === "_ready") {
                        worker.removeEventListener("message", msgListener);
                        worker.onerror = evt => {
                            worker = null;
                            workerPromise = null;
                            console.error("An error occured in the Worker:", ev);
                        }
                        rejectWorkerLoad = null;
                        resolve(worker);
                    }
                };
                worker.addEventListener("message", msgListener);
            })
        }
        return workerPromise;
    }

    function terminateLoadedWorker() {
        if (isWorkerLoaded()) {
            worker.terminate();
            worker = null;
            workerPromise = null;
        }
    }

    function terminateWorker() {

    }

    function isWorkerLoaded() {
        return worker !== null && rejectWorkerLoad === null;
    }

    function isWorkerLoading() {
        return worker !== null && rejectWorkerLoad !== null;
    }

    return {
        ensureWorker,
        terminateWorker,
    }
})();

let runScriptMessageListener = null;
let runSCriptPromiseReject = null;

function runScript(script, appendOutput, updateOps) {
    if (runScriptMessageListener) {
        return Promise.reject("Another script is running.");
    }

    return new Promise((resolve, reject) => {
        appendOutput(`Waiting for Web Worker to finish loading...`);
        workerLoader.ensureWorker().then(worker => {
            appendOutput(`Running script at ${new Date().toISOString()}\n`);
            updateOps(0);
            worker.addEventListener("message", runScriptMessageListener = ev => {
                if (ev.data.req === "runScript/output") {
                    appendOutput(ev.data.output);
                } else if (ev.data.req === "runScript/end") {
                    appendOutput(`Finished at ${new Date().toISOString()}`);
                    worker.removeEventListener("message", runScriptMessageListener);
                    runScriptMessageListener = null;
                    runSCriptPromiseReject = null;
                    resolve();
                } else if (ev.data.req === "runScript/updateOps") {
                    updateOps(ev.data.ops);
                }
            })
            runSCriptPromiseReject = reject;
            let canvas = document.getElementById("canvas");
            let offscreenCanvas = canvas.transferControlToOffscreen();
            worker.postMessage({ req: "setOffScreenCanvas", canvas: offscreenCanvas}, [offscreenCanvas]);
            worker.postMessage({ req: "runScript", script });
        }).catch(e => {
            reject("Cannot load Worker: " + e);
        })
    });
}

function stopScript() {

}

export { runScript, stopScript };
