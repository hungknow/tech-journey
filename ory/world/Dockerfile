from golang as builder

workdir /build
COPY . ./

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o world main.go

from alpine
EXPOSE 8091

COPY --from=builder /build/world world
ENTRYPOINT ["/world"]