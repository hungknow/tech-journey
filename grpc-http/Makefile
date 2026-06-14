include tools/grpc.mk

generate-proto-code: proto-gen-deps
	@-rm -rf $(GEN_DIR)
	@ $(BUF) format -w
	@ $(BUF) generate --template '$(BUF_GEN_TEMPLATE)' .