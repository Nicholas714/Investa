package profile

import (
	"encoding/json"
	"errors"
	"github.com/gorilla/context"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
	"io"
	"net/http"
)

var PasswordConfirmationErr = errors.New("password confirmation incorrect")

type ResetPassword struct {
	PreviousPassword string `json:"previous_password"`
	Password         string `json:"password"`
	ConfirmPassword  string `json:"confirm_password"`
}

func NewResetPassword(r io.Reader) (ResetPassword, error) {
	var reset ResetPassword
	if err := json.NewDecoder(r).Decode(&reset); err != nil {
		return reset, err
	}
	return reset, nil
}

func (r Profile) resetPasswordHandler(w http.ResponseWriter, req *http.Request) {
	user, ok := context.Get(req, "user").(models.User)
	if !ok {
		response.ServerError.Write(w)
		return
	}

	inp, err := NewResetPassword(req.Body)
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	isValid, err := user.ValidPassword(inp.PreviousPassword)
	if err != nil {
		response.ServerError.Write(w)
		return
	}
	if !isValid {
		response.Unauthenticated.Write(w)
		return
	}

	if inp.Password != inp.ConfirmPassword {
		response.NewResponse(400, PasswordConfirmationErr).Write(w)
		return
	}

	if err := user.UpdatePassword(inp.Password); err != nil {
		response.ServerError.Write(w)
		return
	}

	response.Nil.Write(w)
}
