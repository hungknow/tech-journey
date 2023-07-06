package main

import "log"

func main() {
	// Load Config
	serverConfig, err := LoadServerConfig()
	if err != nil {
		log.Panic(err)
	}

	rest := NewRest()
	rest.PrepareRoutes()
	log.Fatal(rest.ListenAndServe(serverConfig.RestPort))
}
