package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/pkg/errors"
)

type Rest struct {
	mux *http.ServeMux
}

func NewRest() *Rest {
	return &Rest{
		mux: http.NewServeMux(),
	}
}

func getTodos(w http.ResponseWriter, r *http.Request) {
	data := map[string]string{"hello": "haha"}
	err := json.NewEncoder(w).Encode(data)
	if err != nil {
		log.Fatal(errors.WithStack(err))
	}
}

func (o *Rest) PrepareRoutes() {
	o.mux.HandleFunc("/todos", getTodos)
}

func (o *Rest) ListenAndServe(listenPort int) error {
	log.Printf("Listen on port %d", listenPort)
	return http.ListenAndServe(fmt.Sprintf(":%d", listenPort), o.mux)
}
