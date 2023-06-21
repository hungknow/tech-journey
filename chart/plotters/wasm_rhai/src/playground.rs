use crate::scripting::prepare_engine;
use rhai::Engine;
use wasm_bindgen::prelude::*;

pub struct Playground {
    engine: Engine,
}

impl Playground {
    pub fn new() -> Self {
        let mut engine = rhai::Engine::new();
        engine.disable_symbol("eval");
        engine.on_print(|_| {});
        engine.on_debug(|_, _, _| {});

        Self {
            engine: Engine::new(),
        }
    }

    pub fn run_script(
        &mut self,
        script: &str,
        print_callback: impl Fn(&str) + 'static,
        debug_callback: impl Fn(&str) + 'static,
        progress_callback: impl Fn(u64) + 'static,
    ) -> Result<String, String> {
        struct Defer<'z> {
            mut_self: &'z mut Playground,
        }
        let defer = Defer { mut_self: self };

        let engine = &mut defer.mut_self.engine;

        engine.on_print(move |s| print_callback(s));
        engine.on_debug(move |s, src, pos| {
            debug_callback(&src.map_or_else(
                || format!("<script>:[{}] {}", pos, s),
                |src| format!("{}:[{}] {}", src, pos, s),
            ))
        });

        let script_ast = engine.compile(&script).map_err(|e| e.to_string())?;

        let result: rhai::Dynamic = engine.eval_ast(&script_ast).map_err(|e| e.to_string())?;

        return Ok(result.to_string());
    }
}

#[wasm_bindgen(js_name = Playground)]
pub struct PlaygroundExport(Playground);

#[wasm_bindgen(js_class = Playground)]
impl PlaygroundExport {
    pub fn new() -> Self {
        Self(Playground::new())
    }

    pub fn run_script(
        &mut self,
        script: String,
        print_callback: js_sys::Function,
        debug_callback: js_sys::Function,
        progress_callback: Option<js_sys::Function>,
    ) -> Result<String, JsValue> {
        Ok(self.0.run_script(
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
}

#[cfg(test)]
mod tests {

    #[test]
    fn testNewPower() {
        //    let playground = Playground::new();
        //    playground.runScript("");
    }
}
