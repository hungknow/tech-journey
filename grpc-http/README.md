- Server implements grpc endpoint
- THe remote client of grpc is implemented on the target programming language for client
- Client can call the server API via gRPC
- Client can call the server API via HTTP


Step:
- Install buf tool from https://docs.buf.build/installation
- Generate go.mod in the root folder
- Generate the tools folder. In the folder, generate the go.mod that contains the packages related to the tool
- cd 'tools', run `go get <package>` to install the grpc plugins
- Generate buf.yaml in the `proto` folder
- Run `make generate-proto-code` command to generate the protobuf file
- Implement the gRPC endpoint on the target programming language
- On the client side, write the example to call the gRPC endpoint on the server side. 


Supported Languages:
- [x] [Golang](#golang)
- [x] [Dart](#dart)
- [ ] Typescript
- [ ] Python
- [ ] C++
- [ ] Rust


# Golang

```
make generate-proto-code
go run go-impl/server/main.go
go run go-impl/client/main.go
```


# Dart

```
dart run dart-impl/server.dart 
dart run dart-impl/client.dart
```
