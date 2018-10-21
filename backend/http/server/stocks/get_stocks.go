package profile

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/tillson/stock-investments/http/response"
	"github.com/tillson/stock-investments/stocks"
)

type GetStocksInput struct {
	Identifier string `json:"identifier"`
}

func NewGetStocksInput(r io.Reader) (GetStocksInput, error) {
	var gsi GetStocksInput
	if err := json.NewDecoder(r).Decode(&gsi); err != nil {
		return gsi, err
	}
	return gsi, nil
}

type GetStocksOutput struct {
	Ticker       string                `json:"ticker"`
	Stocks       []stocks.PriceHistory `json:"stocks"`
	CurrentPrice float64               `json:"current_price"`
}

func (g GetStocksOutput) JSON() (string, error) {
	data, err := json.Marshal(g)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

func (r Stocks) getStocks(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	data, err := NewGetStocksInput(req.Body)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}

	price, time, err := stocks.GetCurrentPrice(data.Identifier)
	if err != nil {
		log.Println(err)
		response.ServerError.Write(w)
		return
	}
	output := GetStocksOutput{
		Ticker: data.Identifier,
		Stocks: []stocks.PriceHistory{{Price: price, Time: time}},
	}
	out, err := output.JSON()
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	fmt.Fprint(w, out)
}

type Price struct {
	Price float64 `json:"price"`
}

func (r Stocks) getStockPrice(w http.ResponseWriter, req *http.Request) {
	ticker := mux.Vars(req)["ticker"]
	price, _, err := stocks.GetCurrentPrice(ticker)
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	j := Price{Price: price}
	out, err := json.Marshal(j)
	if err != nil {
		response.ServerError.Write(w)
		return
	}

	fmt.Fprint(w, string(out))
}
