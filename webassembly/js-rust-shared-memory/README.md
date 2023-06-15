Reference: https://sendilkumarn.com/blog/rustwasm-memory-model

```
rustup target add wasm32-unknown-unknown
cargo fix --lib -p js-rust-shared-memory
cargo build --target="wasm32-unknown-unknown"

npm i

npm run serve
```