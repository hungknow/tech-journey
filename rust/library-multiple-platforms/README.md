- Write a rust library in `crates/lib1` folder.
- In `Cargo.toml`, add the following dependencies and config
```toml
[dependencies]
uniffi = "0.26.1"

[build-dependencies]
uniffi = { version = "0.26.1", features = ["build"] }
```
- Add the `src/lib.udl` file.
- Add the `build.rs` file that compile the `src/lib.udl` file.`
- Create the rust library called `shared_types`.
    - Create `build.rs` file
    - Use `crux_core::typegen` to register Crux App, then generate binding code for the target languages.

# Steps for WASM
- Write a `wasm_bindgen` wrappers for all interfaces in `bindings/wasm`.
- Use `wasm-pack` to generate `.wasm` and `js` files from rs source file. The generated files are stored in `pkg` folder.
- In `js` file, import the `js` in `pkg` folder by code
```ts
import init, { my_method } from './pkg/lib1';

async function start() {
    await init();
    my_method();
}
```

# Steps for Android
- Write a UDL file to describe your interfaces `bindings/ffi`.
- Implement interfaces in Rust code, wrapping returned value in `Arc`.
- Generate uniffi bindings scaffolding during the Cargo build by writing a build.rs file `bindings/ffi/build.rs`
- Get Android NDK and set up Cargo's config to build
- `cargo build --target=blah`

# Steps for IOS