use pyo3::prelude::*;

mod bindings;

pub use bindings::{PyPlayer, PyCell, PyGameState, PyBoard};

#[pymodule]
fn tictactoe(_py: Python, m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_class::<PyPlayer>()?;
    m.add_class::<PyCell>()?;
    m.add_class::<PyGameState>()?;
    m.add_class::<PyBoard>()?;
    Ok(())
}