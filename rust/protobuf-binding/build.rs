use protobuf_codegen::Codegen;

fn main() {
    Codegen::new()
        .protoc()
        .out_dir("src/models")
        .inputs(&[
            "src/protos/user.proto",
            "src/protos/auth.proto",
            "src/protos/errors.proto",
            "src/protos/event_map.proto",
        ])
        .include("src/protos")
        .run()
        .expect("Running rust protoc failed.");
}
