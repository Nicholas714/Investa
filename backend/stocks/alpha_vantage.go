package stocks

import (
	"fmt"
	"time"

	alpha "github.com/cmckee-dev/go-alpha-vantage"
	"github.com/tillson/stock-investments/config"
)

var Tickers = make(map[string]float64)

func GetCurrentPrice(ticker string) (float64, time.Time, error) {
	data, ok := Tickers[ticker]
	fmt.Println("Debug:", ticker, data, ok)
	if ok {
		return data, time.Now(), nil
	}

	api := config.GetAlphaToken()
	c := alpha.NewClient(api)
	series, err := c.StockTimeSeriesIntraday(alpha.TimeIntervalFifteenMinute, ticker)
	if err != nil {
		return 0, time.Now(), err
	}

	last := series[0]

	Tickers[ticker] = last.Close

	return last.Close, last.Time, nil
}

type PriceHistory struct {
	Price float64   `json:"price"`
	Time  time.Time `json:"time"`
}

func GetWeeklyHistory(ticker string) ([]PriceHistory, error) {
	history := make([]PriceHistory, 0)

	api := config.GetAlphaToken()
	c := alpha.NewClient(api)
	series, err := c.StockTimeSeriesIntraday(alpha.TimeIntervalThirtyMinute, ticker)
	if err != nil {
		return history, err
	}

	bow := time.Now().Add(-(time.Hour * 24 * 7))
	for _, s := range series {
		if s.Time.After(bow) {
			history = append(history, PriceHistory{Price: s.Close, Time: s.Time})
		}
	}

	return history, nil
}
