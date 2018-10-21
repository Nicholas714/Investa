package middleware

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/context"
	"github.com/tillson/stock-investments/config"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
	"log"
	"net/http"
)

func (m Middleware) GetUserMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		var bearer string
		header := req.Header.Get("Authorization")
		fmt.Sscanf(header, "Bearer: %s", &bearer)
		type TokenAuth struct {
			jwt.StandardClaims
			ID  int    `json:"id"`
			Exp uint64 `json:"exp"`
		}

		authFunc := func(token *jwt.Token) (interface{}, error) {
			return []byte(config.GetSecret()), nil
		}

		token, err := jwt.ParseWithClaims(bearer, &TokenAuth{}, authFunc)
		if err != nil {
			log.Println(err)
			response.ServerError.Write(w)
			return
		}

		claims, ok := token.Claims.(*TokenAuth)
		if !ok || !token.Valid {
			response.ServerError.Write(w)
			return
		}

		user, err := models.NewUserFromID(claims.ID, m.DB)
		if err != nil {
			log.Println(err)
			response.ServerError.Write(w)
			return
		}

		if !user.Exists() {
			response.Unauthenticated.Write(w)
			return
		}

		user.SetDB(m.DB)
		context.Set(req, "user", user)

		next.ServeHTTP(w, req)
	})
}
