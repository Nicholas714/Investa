package profile

import (
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
)

type Leaderboard struct {
	Router *mux.Router
	DB     *gorm.DB
}

func (r Leaderboard) InitializeHandlers() {
	r.Router.
		HandleFunc("/", r.leaderboardHandler).
		Methods("GET")
}
