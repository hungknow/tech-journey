pub mod bridge_echo;
mod bridge_echo_wasm;
pub use bridge_echo_wasm::*;

pub mod counter;
mod counter_wasm;
pub use counter_wasm::*;

pub struct MyClass {}

impl MyClass {
    pub fn my_method(&self) -> String {
        String::from("This string is from Rust!")
    }
}

pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
