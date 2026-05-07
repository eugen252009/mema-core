FROM ubuntu:24.04

RUN apt-get update && apt-get install -y curl ca-certificates

COPY dist /opt/local-repo

RUN echo "deb [trusted=yes] file:/opt/local-repo ./" > /etc/apt/sources.list.d/mema.list

RUN apt-get update && \
    apt-get install -y mema && \
    apt-get install -y mema-go-latest

RUN echo 'package main; import "fmt"; func main() { fmt.Println("Mema Smoke Test: OK") }' > /tmp/hello.go && \
    /usr/local/bin/go run /tmp/hello.go && \
    rm /tmp/hello.go

