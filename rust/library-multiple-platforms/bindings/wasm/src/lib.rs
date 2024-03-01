use lib1;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub struct MyClass {
    inner: lib1::MyClass,
}

#[wasm_bindgen]
impl MyClass {
    #[wasm_bindgen(constructor)]
    pub fn new() -> MyClass {
        MyClass {
            inner: lib1::MyClass {},
        }
    }

    #[wasm_bindgen]
    pub fn my_method(&self) -> String {
        self.inner.my_method()
    }
}

#[wasm_bindgen]
pub fn create_myclass() -> MyClass {
    MyClass::new()
}
