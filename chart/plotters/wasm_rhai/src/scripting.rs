use crate::RhaiChart;
use rhai::Engine;

pub fn prepare_engine(
    print_callback: impl Fn(&str) + 'static,
    debug_callback: impl Fn(&str) + 'static,
    progress_callback: impl Fn(u64) + 'static,
) -> Engine {
    let mut self_engine = Engine::new();

    self_engine
        .disable_symbol("eval")
        .on_print(move |s| print_callback(s))
        .on_debug(move |s, src, pos| {
            debug_callback(&src.map_or_else(
                || format!("<script>:[{}] {}", pos, s),
                |src| format!("{}:[{}] {}", src, pos, s),
            ));
        });

    // Register the custom types
    self_engine.build_type::<RhaiChart>();

    self_engine
}

pub fn run_script(
    script: &str,
    print_callback: impl Fn(&str) + 'static,
    debug_callback: impl Fn(&str) + 'static,
    progress_callback: impl Fn(u64) + 'static,
) -> Result<String, String> {
    let mut engine = prepare_engine(print_callback, debug_callback, progress_callback);

    let script_ast = engine.compile(&script).map_err(|e| e.to_string())?;
    let result: rhai::Dynamic = engine.eval_ast(&script_ast).map_err(|e| e.to_string())?;
    Ok(result.to_string())
    // let str = String::from("hello1");
    // Ok(str)
}
