package profile

import (
	"encoding/json"
	"fmt"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/stocks"
	"io"
	"log"
	"net/http"
)

type GetStocksInput struct {
	Identifier string `json:"identifier"`
}

func NewGetStocksInput(r io.Reader) (GetStocksInput, error){
	var gsi GetStocksInput
	if err := json.NewDecoder(r).Decode(&gsi); err != nil {
		return gsi, err
	}
	return gsi, nil
}

type GetStocksOutput struct {
	Ticker string `json:"ticker"`
	Stocks []stocks.PriceHistory `json:"stocks"`
	CurrentPrice float64 `json:"current_price"`
}

func (g GetStocksOutput) JSON() (string, error)  {
	data, err := json.Marshal(g)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

// Accept: application/json GET "https://www.blackrock.com/tools/hackathon/security-data?identifiers=IXN"
func (r Stocks) getStocks(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	data, err := NewGetStocksInput(req.Body)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	prices, err := stocks.GetWeeklyHistory(data.Identifier)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	output := GetStocksOutput{
		Ticker: data.Identifier,
		Stocks: prices,
	}
	out, err := output.JSON()
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	fmt.Fprint(w, out)
}
