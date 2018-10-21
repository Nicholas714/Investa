package server

import (
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
	"github.com/tillson/stock-investments/http/middleware"
	"github.com/tillson/stock-investments/http/server/authentication"
	"github.com/tillson/stock-investments/http/server/profile"
	stockD "github.com/tillson/stock-investments/http/server/stocks"
	"net/http"
)

type Server struct {
	router *mux.Router
}

var db *gorm.DB

func NewServer(mDb *gorm.DB) *Server {
	router := mux.NewRouter()
	db = mDb
	return &Server{router: router}
}

func (s *Server) InitializeHandlers() {
	m := middleware.New(db)

	authRouter := s.router.PathPrefix("/auth").Subrouter()
	auth := authentication.Authentication{Router: authRouter, DB: db}
	auth.InitializeHandlers()

	profileRouter := s.router.PathPrefix("/profile").Subrouter()
	profileRouter.Use(m.GetUserMiddleware)
	profileHdlr := profile.Profile{Router: profileRouter, DB: db}
	profileHdlr.InitializeHandlers()

	stocksRouter := s.router.PathPrefix("/stocks").Subrouter()
	stocksF := stockD.Stocks{Router: stocksRouter, DB: db}
	stocksF.InitializeHandlers()


	s.router.Use(m.LoggingMiddleware)
}

func (s *Server) Serve(port string) error {
	return http.ListenAndServe(port, s.router)
}
