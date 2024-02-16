package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func helloWorld(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, world!")
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", helloWorld).Methods("GET")

	http.ListenAndServe(":8000", router)
}
