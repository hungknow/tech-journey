# Purpose

- Create the rust module
- Create the Rust bindings in Python by leverage `PyO3`
- Execute the Python library by `Pyscript`

# Creation flow

- Create Rust library by Cargo
- Add the Math struct and methods
- Create the PyO3 struct fot the Rust structs
- Configure `build.rs` to compile PyO3 by `marturin` targeting `wasm32-unknown-emscripten`
- Create the web app to load `Pyscript` and Python compiled library
- Write the script to execute

# File tree

```
crates
|- 
```