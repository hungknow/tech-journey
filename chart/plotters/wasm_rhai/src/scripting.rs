use rhai::Engine;

pub fn prepare_engine() -> Engine {
    let mut self_engine = Engine::new();
        
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
    let mut engine = prepare_engine();

    let script_ast: Result<rhai::AST, String> = engine.compile(&script).map_err(|e| e.to_string());
    let result = engine.eval_ast(&script_ast).map_err(|e| e.to_string())?;
    Ok(result.to_string())
}
