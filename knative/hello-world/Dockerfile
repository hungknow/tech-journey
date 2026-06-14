FROM golang:latest as builder

WORKDIR /app

COPY go.* ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 go build -v -o server

FROM alpine:3

COPY --from=builder /app/server /server

CMD ["/server"]
