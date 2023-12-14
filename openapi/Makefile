# typescript-axios
TARGET_LANGUAGES ?= go

gen-ory-client:
	docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i /local/yaml/ory-client.json \
    -g $(TARGET_LANGUAGES) \
    -o /local/out/ory/client/$(TARGET_LANGUAGES)