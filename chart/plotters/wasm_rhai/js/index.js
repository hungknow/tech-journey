const plotterWasmImport = import("plotter-wasm/plotter_wasm");
const bootstrapImport = import("./bootstrap");
const buefyCssImport = import("buefy/dist/buefy.css");

let embedWaitPromise;
if (window.location.hash.startsWith("#embed-") && window.parent !== window) {
	const id = window.location.hash.substr(7);
	let embedResolve;
	embedWaitPromise = new Promise((resolve, _reject) => {
		embedResolve = resolve;
	});
	const loading = document.createElement("div");
	loading.innerText = "(embedded)";
	document.getElementById("loading").appendChild(loading);
} else {
	embedWaitPromise = Promise.resolve(null);
}

Promise.all([bootstrapImport, embedWaitPromise, plotterWasmImport, buefyCssImport]).then(([m, embedInit, _wasm, _buefyCss]) => {
	document.getElementById("loading").remove();
	m.default("#topContainer", embedInit);
})