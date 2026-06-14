package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Response struct {
	Message string `json:"message"`
}

func worldHandler(w http.ResponseWriter, r *http.Request) {
	response := Response{Message: "world"}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func main() {
	http.HandleFunc("/", worldHandler)
	log.Fatal(http.ListenAndServe(":8091", nil))
}
