Reference: https://gpalma.pt/blog/flutter-web-web-assembly/

- Install
    `cargo install --version 0.10.3 wasm-pack`
    `cargo install cargo-generate`

- `export CARGO_NET_GIT_FETCH_WITH_CLI=true`


# Create the new wasm rust-js project
- Create the new project
    `wasm-pack new addition`
    OR
    `cargo generate --git https://github.com/rustwasm/wasm-pack-template.git --name addition`
- Build
    `wasm-pack build -t web`

# Rust project
- `cargo new rust-crypto-module`
- Add the function implementation
- Build: `wasm-pack build --target no-modules`

# Dart project
- `flutter create --platforms web flutterapp`
- Copy the generated wasm and js into the flutter web
    `cp rust-crypto-module/pkg/rust_crypto_module* flutterapp/web/pkg`
- Add `<script src="pkg/rust_crypto_module.js" defer> </script>` in the index.html file
- `flutter run -d chrome`