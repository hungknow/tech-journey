use wasm_bindgen::JsCast;
use web_sys::{window, HtmlCanvasElement, OffscreenCanvas};

pub fn canvas_id_to_offscreen_canvas(canvas_id: &str) -> Option<OffscreenCanvas> {
    let document = window()?.document()?;
    let canvas = document.get_element_by_id(canvas_id)?;
    let canvas: HtmlCanvasElement = canvas.dyn_into().ok()?;
    let offscreen_canvas = canvas.transfer_control_to_offscreen().unwrap();
    Some(offscreen_canvas)
}