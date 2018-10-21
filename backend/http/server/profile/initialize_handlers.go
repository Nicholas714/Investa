package profile

import (
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
)

type Profile struct {
	Router *mux.Router
	DB     *gorm.DB
}

func (r Profile) InitializeHandlers() {
	r.Router.
		HandleFunc("/", r.profileHandler).
		Methods("GET")
	r.Router.
		HandleFunc("/resetpassword", r.resetPasswordHandler).
		Methods("POST")
}
