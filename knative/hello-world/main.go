package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
)

func defaultGet(writer http.ResponseWriter, req *http.Request) {
	writer.WriteHeader(http.StatusOK)

	content := "hello world\n"
	writer.Write([]byte(content))
}

func main() {
	port := "8021"
	ln, err := net.Listen("tcp", fmt.Sprintf(":%s", port))
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", defaultGet)
	log.Printf("Listen HTTP on port %s", port)
	http.Serve(ln, http.DefaultServeMux)
}