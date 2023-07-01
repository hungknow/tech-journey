import { Chart } from "plotter-wasm/plotter_wasm";
import "buefy/dist/buefy.css";

let chart = null;

const canvas = document.getElementById("canvas");
const coord = document.getElementById("coord");
const plotType = document.getElementById("plot-type");
const pitch = document.getElementById("pitch");
const yaw = document.getElementById("yaw");
const control = document.getElementById("3d-control");
const status = document.getElementById("status");

// export function setup(WasmChart) {
//     Chart = WasmChart;
// }

export function main() {
    let hash = location.hash.substr(1);
	for(var i = 0; i < plotType.options.length; i++) {
		if(hash == plotType.options[i].value) {
			plotType.value = hash;
		}
	}
    setupUI();
    setupCanvas();
}

function setupUI() {
    status.innerText = "WebAssembly loaded!";
    plotType.addEventListener("change", updatePlot);
	yaw.addEventListener("change", updatePlot);
	pitch.addEventListener("change", updatePlot);
	yaw.addEventListener("input", updatePlot);
	pitch.addEventListener("input", updatePlot);
    window.addEventListener("resize", setupCanvas);
    window.addEventListener("mousemove", onMouseMove);
}

function setupCanvas() {
	const dpr = window.devicePixelRatio || 1.0;
    const aspectRatio = canvas.width / canvas.height;
    const size = canvas.parentNode.offsetWidth * 0.8;
    canvas.style.width = size + "px";
    canvas.style.height = size / aspectRatio + "px";
    canvas.width = size;
    canvas.height = size / aspectRatio;
    updatePlot();
}

function onMouseMove(event) {
    if (chart) {
		var text = "Mouse pointer is out of range";

		if(event.target == canvas) {
			let actualRect = canvas.getBoundingClientRect();
			let logicX = event.offsetX * canvas.width / actualRect.width;
			let logicY = event.offsetY * canvas.height / actualRect.height;
			const point = chart.coord(logicX, logicY);
			text = (point) 
				? `(${point.x.toFixed(3)}, ${point.y.toFixed(3)})`
				: text;
		}
        coord.innerText = text;
    }
}

function updatePlot3d() {
	let yaw_value = Number(yaw.value) / 100.0;
	let pitch_value = Number(pitch.value) / 100.0;
	Chart.plot3d(canvas, pitch_value, yaw_value);
	coord.innerText = `Pitch:${pitch_value}, Yaw:${yaw_value}`
}

function updatePlot() {
    const selected = plotType.selectedOptions[0];
    status.innerText = `Rendering ${selected.innerText}...`;
    chart = null;
    const start = performance.now();
	switch(selected.value) {
		case "mandelbrot":
			control.classList.add("hide");
			chart = Chart.mandelbrot(canvas);
			break;
		case "3d-plot": 
			control.classList.remove("hide");
			updatePlot3d();
			break;
		default:
			control.classList.add("hide");
			chart = Chart.power("canvas", Number(selected.value))
	}
	
    const end = performance.now();
    status.innerText = `Rendered ${selected.innerText} in ${Math.ceil(end - start)}ms`;
}