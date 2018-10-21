package profile

import (
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/models"
	"log"
	"net/http"
)

type Portfolio struct {
	Username string `json:"username"`
	Name string `json:"name"`
	PortfolioValue float64 `json:"portfolio_value"`
}

type Portfolios struct {

}

func (l Leaderboard) leaderboardHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var users []models.User
	if err := l.DB.Table("users").Scan(&users).Error; err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	for _, user := range users {
		_, err := user.GetPortfolioValue()
		if err != nil {
			log.Println(err)
			response.ServerError.Write(w)
			return
		}
	}

	response.Nil.Write(w)
}
