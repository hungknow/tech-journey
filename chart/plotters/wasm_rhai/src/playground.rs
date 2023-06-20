use crate::{scripting::prepare_engine};
use rhai::Engine;
use wasm_bindgen::prelude::wasm_bindgen;

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

    pub fn runScript(
        &mut self,
        script: &str,

    ) -> Result<String, String> {
        struct Defer<'z> {
            mut_self: &'z mut Playground,
        }
        let defer = Defer { mut_self: self };

        let engine = &mut defer.mut_self.engine;

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
}

#[cfg(test)]
mod tests {
    
    #[test]
    fn testNewPower() {
    //    let playground = Playground::new();
    //    playground.runScript("");
    }
}