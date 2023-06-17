mod func_plot;
mod mandelbrot;
mod plot3d;
mod playground;
mod scripting;

use rhai::TypeBuilder;
use wasm_bindgen::prelude::*;
use web_sys::HtmlCanvasElement;

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
    pub fn power(canvas_id: &str, power: i32) -> Result<Chart, JsValue> {
        let map_coord = func_plot::draw(canvas_id, power).map_err(|err| err.to_string())?;
        Ok(Chart {
            convert: Box::new(move |coord| map_coord(coord).map(|(x, y)| (x.into(), y.into()))),
        })
    }

    pub fn mandelbrot(canvas: HtmlCanvasElement) -> Result<Chart, JsValue> {
        let map_coord = mandelbrot::draw(canvas).map_err(|err| err.to_string())?;
        Ok(Chart {
            convert: Box::new(map_coord),
        })
    }

    pub fn plot3d(canvas: HtmlCanvasElement, pitch: f64, yaw: f64) -> Result<(), JsValue> {
        plot3d::draw(canvas, pitch, yaw).map_err(|err| err.to_string())?;
        Ok(())
    }

    pub fn coord(&self, x: i32, y: i32) -> Option<Point> {
        (self.convert)((x, y)).map(|(x, y)| Point { x, y })
    }

}

#[derive(Clone)]
pub struct RhaiChart {
    // canvas_id: str, 
}

impl RhaiChart {
    pub fn new_power(canvas_id: &str, power: i32) -> Self {
        let map_coord = func_plot::draw(canvas_id, power).map_err(|err| err.to_string()).unwrap();
        RhaiChart {
            // canvas_id: canvas_id,
            // convert: Box::new(move |coord| map_coord(coord).map(|(x, y)| (x.into(), y.into()))),
        }
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
}