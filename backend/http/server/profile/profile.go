package profile

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/context"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
)

type Return struct {
	Name     string  `json:"name"`
	Username string  `json:"username"`
	Email    string  `json:"email"`
	Funds    float64 `json:"funds"`
	Value    float64 `json:"value"`
}

func (r Return) JSON() (string, error) {
	out, err := json.Marshal(r)
	if err != nil {
		return "", err
	}
	return string(out), err
}

func (r Profile) profileHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	user, ok := context.Get(req, "user").(models.User)
	if !ok {
		log.Println("1")
		response.ServerError.Write(w)
		return
	}

	val, err := user.GetPortfolioValue()
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	userData := Return{
		Username: user.Username,
		Name:     user.Name,
		Funds:    user.Funds,
		Value:    val,
	}

	out, err := userData.JSON()
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	fmt.Fprint(w, out)
}
