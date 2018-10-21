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
	User User

	PriceAtTime float64
	Type TxType
}

func CreateTransaction(tx Transaction, db *gorm.DB) error {
	if err := db.Create(tx).Error; err != nil {
		return err
	}

	return nil
}
