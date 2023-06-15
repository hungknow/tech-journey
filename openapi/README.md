Use [`openapi-generator`](https://github.com/OpenAPITools/openapi-generator) to generate the MySQL schema, API client libraries on the target programming language.

```
docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i /local/yaml/echo.yaml \
    -g go \
    -o /local/out/go
```