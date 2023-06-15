package main

import (
	"fmt"
	"log"
	"net/http"
)

// Receive the multipart file, then upload it

func main() {
	// Start the thtp server
	http.HandleFunc("/upload-file", uploadFile)
	port := 5005

	fmt.Printf("Listen on port %d", port)
	err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}

func uploadFile(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("Receive uploadFile\n")
}
