package models

import (
	"github.com/jinzhu/gorm"
)

type TxType string

var Buy TxType = "BUY"
var Sell TxType = "SELL"

type Transaction struct {
	gorm.Model
	db *gorm.DB

	Ticker string

	UserID uint
	User   User

	PriceAtTime float64
	Type        TxType

	Quantity uint
}

func CreateTransaction(tx Transaction, db *gorm.DB) error {
	if err := db.Create(&tx).Error; err != nil {
		return err
	}

	return nil
}

func StockMap(userID uint, db *gorm.DB) (map[string]uint, error) {
	stockMap := make(map[string]uint)

	var txs []Transaction
	if err := db.Model(User{}).Where("id = ?", userID).Related(&txs).Error; err != nil {
		return stockMap, err
	}

	for _, tx := range txs {
		if tx.Type == Buy {
			stockMap[tx.Ticker] += tx.Quantity
		} else {
			stockMap[tx.Ticker] -= tx.Quantity
		}
	}

	return stockMap, nil
}
