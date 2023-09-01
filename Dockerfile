FROM golang:1.20-buster as builder
RUN mkdir /app
WORKDIR /app

RUN export GO111MODULE=on

COPY ./ ./

RUN go mod download
RUN go build -v -o server

FROM debian:buster-slim

ENV GOPATH=/go \
    PATH=/go/bin:$PATH

RUN apt-get update && apt-get install -y golang-go

WORKDIR /app


COPY --from=builder /app/server ./server

EXPOSE 9000

CMD ["./server"]