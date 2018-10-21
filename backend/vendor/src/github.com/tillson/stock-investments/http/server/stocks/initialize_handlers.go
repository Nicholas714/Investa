package profile

import (
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
)

type Stocks struct {
	Router *mux.Router
	DB     *gorm.DB
}

func (r Stocks) InitializeHandlers() {
	r.Router.
		HandleFunc("/", r.getStocks).
		Methods("POST")
	r.Router.
		HandleFunc("/buy", r.buyStocks).
		Methods("POST")
	r.Router.
		HandleFunc("/sell", r.sellStocks).
		Methods("POST")
}
