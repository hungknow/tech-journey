use std::cell::RefCell;
use std::panic;

mod canvas_utils;
mod func_plot;
// mod mandelbrot;
// mod plot3d;
mod playground;
mod scripting;

use playground::globalOffscreenCanvas;
use rhai::TypeBuilder;
use wasm_bindgen::prelude::*;
use web_sys::OffscreenCanvas;

/// Type alias for the result of a drawing function.
pub type DrawResult<T> = Result<T, Box<dyn std::error::Error>>;

#[wasm_bindgen]
pub struct Chart {
    convert: Box<dyn Fn((i32, i32)) -> Option<(f64, f64)>>,
}

#[wasm_bindgen]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

#[wasm_bindgen]
impl Chart {
    // pub fn power(canvas_id: &str, power: i64) -> Result<Chart, JsValue> {
    //     let map_coord =
    //         func_plot::draw_on_canvas_id(canvas_id, power).map_err(|err| err.to_string())?;
    //     Ok(Chart {
    //         convert: Box::new(move |coord| map_coord(coord).map(|(x, y)| (x.into(), y.into()))),
    //     })
    // }

    // pub fn power_offscreen(canvas: OffscreenCanvas, power: i64) -> Result<Chart, JsValue> {
    //     let map_coord = func_plot::draw_on_offscreen_canvas(canvas, power).map_err(|err| err.to_string())?;
    //     Ok(Chart {
    //         convert: Box::new(move |coord| map_coord(coord).map(|(x, y)| (x.into(), y.into()))),
    //     })
    // }

    // pub fn mandelbrot(canvas: HtmlCanvasElement) -> Result<Chart, JsValue> {
    //     let map_coord = mandelbrot::draw(canvas).map_err(|err| err.to_string())?;
    //     Ok(Chart {
    //         convert: Box::new(map_coord),
    //     })
    // }

    // pub fn plot3d(canvas: HtmlCanvasElement, pitch: f64, yaw: f64) -> Result<(), JsValue> {
    //     plot3d::draw(canvas, pitch, yaw).map_err(|err| err.to_string())?;
    //     Ok(())
    // }

    pub fn coord(&self, x: i32, y: i32) -> Option<Point> {
        (self.convert)((x, y)).map(|(x, y)| Point { x, y })
    }
}

#[derive(Clone)]
pub struct RhaiChart {
    // canvas_id: &'x str,
    // chart: &Chart,
    canvas: OffscreenCanvas,
}

// type OffsetCanvasRef = Rc<RefCell<RhaiChart>>;
// static mut rhaiChart: RhaiChart = RhaiChart{
// canvas_id: "canvas",
// };

impl RhaiChart {
    pub fn set_canvas_id(canvas_id: &str) {
        // unsafe { rhaiChart.canvas_id = canvas_id };
    }

    pub fn new_power(power: i64) {
        unsafe {
            // if globalOffscreenCanvas == None {
            //     let map_coord = func_plot::draw_on_canvas_id("canvas", power)
            //         .map_err(|err| err.to_string())
            //         .unwrap();
            // } else {
                let canvas = globalOffscreenCanvas.as_ref().unwrap();
                // let canvas = globalOffscreenCanvas.unwrap();
                func_plot::draw_on_offscreen_canvas(canvas, power);
            // }
        }
        // RhaiChart {
        // canvas_id: canvas_id,
        // convert: Box::new(move |coord| map_coord(coord).map(|(x, y)| (x.into(), y.into()))),
        // }
    }
}

// For rhai type
// https://rhai.rs/book/rust/build_type.html
impl rhai::CustomType for RhaiChart {
    fn build(mut builder: TypeBuilder<Self>) {
        builder
            .with_name("Chart")
            .with_fn("new_power", Self::new_power);
    }
}

#[wasm_bindgen]
pub fn run_script(
    script: String,
    print_callback: js_sys::Function,
    debug_callback: js_sys::Function,
    progress_callback: Option<js_sys::Function>,
) -> Result<String, JsValue> {
    panic::set_hook(Box::new(console_error_panic_hook::hook));
    Ok(scripting::run_script(
        &script,
        move |s| {
            let _ = print_callback.call1(&JsValue::null(), &JsValue::from_str(s));
        },
        move |s| {
            let _ = debug_callback.call1(&JsValue::null(), &JsValue::from_str(s));
        },
        move |ops| {
            if let Some(f) = &progress_callback {
                let _ = f.call1(&JsValue::null(), &JsValue::from_f64(ops as f64));
            }
        },
    )?)
}

pub fn set_panic_hook() {
    // When the `console_error_panic_hook` feature is enabled, we can call the
    // `set_panic_hook` function at least once during initialization, and then
    // we will get better error messages if our code ever panics.
    //
    // For more details see
    // https://github.com/rustwasm/console_error_panic_hook#readme
    #[cfg(feature = "console_error_panic_hook")]
    console_error_panic_hook::set_once();
}
