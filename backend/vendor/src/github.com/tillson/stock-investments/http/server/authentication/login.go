package authentication

import (
	"encoding/json"
	"fmt"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
	"io"
	"log"
	"net/http"

)

type LoginInput struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func NewLoginInput(body io.Reader) (LoginInput, error) {
	var inp LoginInput
	if err := json.NewDecoder(body).Decode(&inp); err != nil {
		return inp, err
	}
	return inp, nil
}

type LoginReturn struct {
	Username    string `json:"username"`
	Email       string `json:"email"`
	AccessToken string `json:"access_token"`
	AvatarURL   string `json:"avatar_url"`
}

func (r Authentication) loginHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	inp, err := NewLoginInput(req.Body)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	if inp.Username == "" {
		response.Unauthenticated.Write(w)
		return
	}

	user, err := models.NewUserFromUsername(inp.Username, r.DB)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	if !user.Exists() {
		response.Unauthenticated.Write(w)
		return
	}

	isValid, err := user.ValidPassword(inp.Password)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	if !isValid {
		response.Unauthenticated.Write(w)
		return
	}

	tokenString, err := user.JWTTokenJSON()
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	fmt.Fprintf(w, string(tokenString))
}
