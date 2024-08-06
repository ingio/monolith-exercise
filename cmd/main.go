package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func main() {

	httpPort, exists := os.LookupEnv("PORT")
	if !exists {
		httpPort = "8080"
	}
	mux := http.NewServeMux()
	mux.HandleFunc("/", rootHandler)
	fmt.Println("Go server Listening on: ", httpPort)
	log.Fatal(http.ListenAndServe(":"+httpPort, mux))
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		w.WriteHeader(http.StatusOK)
		io.WriteString(w, "monolith\n")
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
		io.WriteString(w, "Error: Method not allowed\n")
	}
}
