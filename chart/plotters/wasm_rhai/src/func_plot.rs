use crate::{DrawResult, canvas_utils::canvas_id_to_offscreen_canvas};
use plotters::{prelude::*, coord::Shift};
use plotters_offscreen_canvas::OffscreenCanvasBackend;
use web_sys::OffscreenCanvas;

/// Draw power function f(x) = x^power.
pub fn draw_on_canvas_id(canvas_id: &str, power: i64) -> DrawResult<impl Fn((i32, i32)) -> Option<(f32, f32)>> {
    let canvas = canvas_id_to_offscreen_canvas(canvas_id).unwrap();
    draw_on_offscreen_canvas(canvas, power)
}

pub fn draw_on_offscreen_canvas(canvas: OffscreenCanvas, power: i64)-> DrawResult<impl Fn((i32, i32)) -> Option<(f32, f32)>> { 
    let backend = OffscreenCanvasBackend::new(canvas).expect("cannot find canvas");
    draw_on_drawing_area(&backend.into_drawing_area(), power)
}

pub fn draw_on_drawing_area(root: &DrawingArea<OffscreenCanvasBackend, Shift>, power: i64) -> DrawResult<impl Fn((i32, i32)) -> Option<(f32, f32)>>  {
    let font: FontDesc = ("sans-serif", 20.0).into();
    root.fill(&WHITE)?;

    let mut chart = ChartBuilder::on(&root)
        .margin(20u32)
        .caption(format!("y=x^{}", power), font)
        .x_label_area_size(30u32)
        .y_label_area_size(30u32)
        .build_cartesian_2d(-1f32..1f32, -1.2f32..1.2f32)?;

    chart.configure_mesh().x_labels(3).y_labels(3).draw()?;

    chart.draw_series(LineSeries::new(
        (-50..=50)
            .map(|x| x as f32 / 50.0)
            .map(|x| (x, x.powf(power as f32))),
        &RED,
    ))?;

    root.present()?;
    return Ok(chart.into_coord_trans());
}