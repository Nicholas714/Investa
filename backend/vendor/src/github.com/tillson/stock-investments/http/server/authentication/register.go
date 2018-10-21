package authentication

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
	"io"
	"log"
	"net/http"
)

type RegisterInput struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func NewRegisterInput(b io.Reader) (RegisterInput, error) {
	var inp RegisterInput
	if err := json.NewDecoder(b).Decode(&inp); err != nil {
		return inp, err
	}
	return inp, nil
}

func (r Authentication) registerHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Get data from JSON
	inp, err := NewRegisterInput(req.Body)
	if err != nil {
		log.Println("error parsing JSON")
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	if inp.Username == "" {
		response.NewResponse(400, errors.New("username not defined")).Write(w)
		return
	}

	// Check if user exists
	targetUser, err := models.NewUserFromUsername(inp.Username, r.DB)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	if targetUser.Exists() {
		response.NewResponse(400, errors.New("username already exists")).Write(w)
		return
	}

	// Create user
	user, err := models.CreateUser(inp.Username, inp.Password, r.DB)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	tokenString, err := user.JWTTokenJSON()
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	fmt.Fprint(w, string(tokenString))
}
