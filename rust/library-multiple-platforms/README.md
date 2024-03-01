- Write a rust library in `crates/lib1` folder.

# Steps for WASM
- Write a `wasm_bindgen` wrappers for all interfaces in `bindings/wasm`.
- Use `wasm-pack` to generate `.wasm` and `js` files from rs source file. The generated files are stored in `pkg` folder.

# Steps for Android
- Write a UDL file to describe your interfaces `bindings/ffi`.
- Implement interfaces in Rust code, wrapping returned value in `Arc`.
- Generate uniffi bindings scaffolding during the Cargo build by writing a build.rs file `bindings/ffi/build.rs`
- Get Android NDK and set up Cargo's config to build
- `cargo build --target=blah`

# Steps for IOS