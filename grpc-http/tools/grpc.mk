XDG_CACHE_HOME ?= $(HOME)/.cache
TOOLS_BIN_DIR := $(abspath $(XDG_CACHE_HOME)/hk/bin)
TOOLS_MOD := tools/go.mod

BUF := $(TOOLS_BIN_DIR)/buf

GEN_DIR := gen/proto
GEN_DIR_GO := $(GEN_DIR)/go
GEN_DIR_DART := $(GEN_DIR)/dart
GEN_DIR_PYTHON := $(GEN_DIR)/python
JSONSCHEMA_DIR := schema/jsonschema
OPENAPI_DIR := schema/openapiv2
PROTOC_GEN_GO := $(TOOLS_BIN_DIR)/protoc-gen-go
PROTOC_GEN_GO_GRPC := $(TOOLS_BIN_DIR)/protoc-gen-go-grpc
PROTOC_GEN_GO_HASHPB := $(TOOLS_BIN_DIR)/protoc-gen-go-hashpb
PROTOC_GEN_GO_VTPROTO := $(TOOLS_BIN_DIR)/protoc-gen-go-vtproto
PROTOC_GEN_GRPC_GATEWAY := $(TOOLS_BIN_DIR)/protoc-gen-grpc-gateway
PROTOC_GEN_JSONSCHEMA := $(TOOLS_BIN_DIR)/protoc-gen-jsonschema
PROTOC_GEN_OPENAPIV2 := $(TOOLS_BIN_DIR)/protoc-gen-openapiv2
PROTOC_GEN_VALIDATE := $(TOOLS_BIN_DIR)/protoc-gen-validate
PROTOC_GEN_DART :=  $(HOME)/.pub-cache/bin/protoc-gen-dart
PROTOC_GEN_GRPC_PYTHON := grpc-env/bin/protoc-gen-grpclib_python

define BUF_GEN_TEMPLATE
{\
  "version": "v1",\
  "plugins": [\
    {\
      "name": "go",\
      "out": "$(GEN_DIR_GO)",\
      "opt": "paths=source_relative",\
      "path": "$(PROTOC_GEN_GO)"\
    },\
    {\
      "name": "vtproto",\
      "out": "$(GEN_DIR_GO)",\
      "opt": [\
	    "paths=source_relative",\
	  	"features=marshal+unmarshal+size"\
	  ],\
      "path": "$(PROTOC_GEN_GO_VTPROTO)"\
    },\
    {\
      "name": "validate",\
      "opt": [\
        "paths=source_relative",\
        "lang=go"\
      ],\
      "out": "$(GEN_DIR_GO)",\
      "path": "$(PROTOC_GEN_VALIDATE)"\
    },\
    {\
      "name": "go-grpc",\
      "opt": "paths=source_relative",\
      "out": "$(GEN_DIR_GO)",\
      "path": "$(PROTOC_GEN_GO_GRPC)"\
    },\
    {\
      "name": "go-hashpb",\
      "opt": "paths=source_relative",\
      "out": "$(GEN_DIR_GO)",\
      "path": "$(PROTOC_GEN_GO_HASHPB)"\
    },\
    {\
      "name": "grpc-gateway",\
      "opt": "paths=source_relative",\
      "out": "$(GEN_DIR_GO)",\
      "path": "$(PROTOC_GEN_GRPC_GATEWAY)"\
    },\
    {\
      "name": "openapiv2",\
      "out": "$(OPENAPI_DIR)",\
      "path": "$(PROTOC_GEN_OPENAPIV2)"\
    },\
  ]\
}
endef

    # {\
    #   "name": "dart",\
    #   "out": "$(GEN_DIR_DART)",\
    #   "path": "/home/hung/.pub-cache/bin/protoc-gen-dart"\
    # },\

$(TOOLS_BIN_DIR):
	@ mkdir -p $(TOOLS_BIN_DIR)

$(BUF): $(TOOLS_BIN_DIR)
	GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/bufbuild/buf/cmd/buf

$(PROTOC_GEN_GO): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) google.golang.org/protobuf/cmd/protoc-gen-go

$(PROTOC_GEN_GO_GRPC): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) google.golang.org/grpc/cmd/protoc-gen-go-grpc

$(PROTOC_GEN_GO_HASHPB): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/cerbos/protoc-gen-go-hashpb

$(PROTOC_GEN_GO_VTPROTO): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/planetscale/vtprotobuf/cmd/protoc-gen-go-vtproto

$(PROTOC_GEN_GRPC_GATEWAY): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway

$(PROTOC_GEN_JSONSCHEMA): $(TOOLS_BIN_DIR) $(PROTOC_GEN_JSONSCHEMA_SRC_FILES)
	@ cd $(PROTOC_GEN_JSONSCHEMA_SRC_DIR) && GOBIN=$(TOOLS_BIN_DIR) go install .

$(PROTOC_GEN_OPENAPIV2): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2

$(PROTOC_GEN_VALIDATE): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/envoyproxy/protoc-gen-validate
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) google.golang.org/protobuf/cmd/protoc-gen-go

$(PROTOC_GEN_GO_VTPROTO): $(TOOLS_BIN_DIR)
	@ GOBIN=$(TOOLS_BIN_DIR) go install -modfile=$(TOOLS_MOD) github.com/planetscale/vtprotobuf/cmd/protoc-gen-go-vtproto

# install-dart:
  # dart pub global activate protoc_plugin
dart-generate:
	@ mkdir -p $(GEN_DIR_DART)
	@ protoc --plugin="protoc-gen-dart=$(PROTOC_GEN_DART)" --experimental_allow_proto3_optional -I=./proto  --proto_path=../googleapis --proto_path=../protobuf/src --dart_out=grpc:$(GEN_DIR_DART) proto/hk/v1/petstore.proto ../googleapis/google/type/*.proto ../protobuf/src/google/protobuf/*.proto

go-gen: $(PROTOC_GEN_GO) $(PROTOC_GEN_GO_VTPROTO) $(PROTOC_GEN_GO_GRPC) $(PROTOC_GEN_GRPC_GATEWAY) $(PROTOC_GEN_OPENAPIV2) $(PROTOC_GEN_VALIDATE) $(PROTOC_GEN_GO_HASHPB) 
dart-gen: dart-generate

python-gen:
	@ mkdir -p $(GEN_DIR_PYTHON)
	python -m venv grpc-env
	. grpc-env/bin/activate; \
  python -m pip install grpcio grpclib protobuf;\
  protoc --plugin="protoc-gen-grpc_python=$(PROTOC_GEN_GRPC_PYTHON)" -I=./proto  --proto_path=../googleapis --proto_path=../protobuf/src --python_out=$(GEN_DIR_PYTHON) --grpc_python_out=$(GEN_DIR_PYTHON) proto/hk/v1/petstore.proto

.PHONY: proto-gen-deps dart-gen go-gen
proto-gen-deps: $(BUF) go-gen dart-gen python-gen
grpc-http-clean:
	rm -rf ./grpc-env
	rm -rf ./gen
	rm -rf ./api
	rm -rf ./.dart_tool
	rm -rf ./schema
