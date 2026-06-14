use std::path::PathBuf;

use crux_core::typegen::TypeGen;
use lib1::counter::Counter;

fn main() -> anyhow::Result<()> {
    let mut gen = TypeGen::new();

    gen.register_app::<Counter>()?;

    let output_root = PathBuf::from("./generated");

    gen.typescript("shared_types", output_root.join("typescript"))?;

    Ok(())
}