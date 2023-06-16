use rhai::Engine;

pub struct Playground {
    engine: Engine,
}

impl Playground {
    pub fn new() -> Self {
        let mut engine = rhai::Engine::new();
        Self {
            engine: Engine::new(),
        }
    }
}