from golang as builder

workdir /build
COPY . ./

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o hello main.go

from alpine
EXPOSE 8090

COPY --from=builder /build/hello hello
ENTRYPOINT ["/hello"]