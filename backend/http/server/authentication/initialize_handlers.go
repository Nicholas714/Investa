package authentication

import (
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
)

type Authentication struct {
	Router *mux.Router
	DB     *gorm.DB
}

func (r Authentication) InitializeHandlers() {
	r.Router.
		HandleFunc("/login", r.loginHandler).
		Methods("POST")
	r.Router.
		HandleFunc("/register", r.registerHandler).
		Methods("POST")
}
