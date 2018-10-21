package models

import (
	"encoding/json"
	"errors"
	"time"

	"github.com/tillson/stock-investments/config"
	"github.com/tillson/stock-investments/stocks"

	"github.com/dgrijalva/jwt-go"
	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model

	db *gorm.DB

	Username     string `gorm:"unique"`
	PasswordHash []byte

	Transactions []Transaction

	Funds float64

	Name string
}

func NewUserFromID(id int, db *gorm.DB) (User, error) {
	var user User
	if err := db.Where("id = ?", id).First(&user).Error; err != nil {
		if !gorm.IsRecordNotFoundError(err) {
			return user, err
		}
	}

	user.db = db

	return user, nil
}

func NewUserFromUsername(username string, db *gorm.DB) (User, error) {
	var user User
	if err := db.Where("username = ?", username).First(&user).Error; err != nil {
		if !gorm.IsRecordNotFoundError(err) {
			return user, err
		}
	}

	user.db = db

	return user, nil
}

func CreateUser(username, password, name string, db *gorm.DB) (User, error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return User{}, err
	}

	user := User{
		Name:         name,
		Username:     username,
		PasswordHash: passwordHash,
		Funds:        config.GetStartMoney(),
	}

	if err := db.Create(&user).Error; err != nil {
		return User{}, err
	}

	return user, nil
}

// Exists returns true if the user exists
func (user *User) Exists() bool {
	return user.ID != 0
}

func (user *User) SetDB(db *gorm.DB) {
	user.db = db
}

func (user *User) JWTTokenJSON() (string, error) {
	token := jwt.NewWithClaims(config.GetJWTSigningMethod(), jwt.MapClaims{
		"id":  user.ID,
		"exp": time.Now().Add(24 * time.Hour).Unix(),
	})

	tokenString, err := token.SignedString([]byte(config.GetSecret()))
	if err != nil {
		return "", err
	}

	j := struct {
		AccessToken string `json:"access_token"`
	}{AccessToken: tokenString}

	out, err := json.Marshal(j)
	if err != nil {
		return "", err
	}

	return string(out), nil
}

func (user *User) ValidPassword(password string) (bool, error) {
	err := bcrypt.CompareHashAndPassword(user.PasswordHash, []byte(password))
	if err == bcrypt.ErrMismatchedHashAndPassword {
		return false, nil
	}
	if err != nil {
		return false, err
	}

	return true, nil
}

func (user *User) UpdatePassword(password string) error {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	if err := user.db.Model(&user).Update("password_hash", passwordHash).Error; err != nil {
		return err
	}

	return nil
}

var NotEnoughMoneyErr = errors.New("not enough money")

func (user *User) BuyStock(ticker string, quantity uint) (Transaction, error) {
	// Check current price of stock
	price, _, err := stocks.GetCurrentPrice(ticker)
	if err != nil {
		return Transaction{}, err
	}
	totalPrice := price * float64(quantity)
	// Validate current_price * quantity <= user.Money
	if totalPrice > float64(user.Funds) {
		return Transaction{}, NotEnoughMoneyErr
	}
	if err := user.db.Model(&user).Update("funds", (user.Funds - totalPrice)).Error; err != nil {
		return Transaction{}, err
	}

	tx := Transaction{
		Ticker:      ticker,
		PriceAtTime: price,
		UserID:      user.ID,
		Type:        Buy,
		Quantity:    quantity,
	}
	if err := CreateTransaction(tx, user.db); err != nil {
		return tx, err
	}

	return tx, nil
}

var NotEnoughStocksErr = errors.New("you do not have enough stocks")

func (user *User) SellStock(ticker string, quantity uint) (Transaction, error) {
	// Check current price of stock
	price, _, err := stocks.GetCurrentPrice(ticker)
	if err != nil {
		return Transaction{}, err
	}

	stockMap, err := StockMap(user.ID, user.db)
	if err != nil {
		return Transaction{}, err
	}
	count := stockMap[ticker]

	// Validate user has number of stocks
	if count < quantity {
		return Transaction{}, NotEnoughStocksErr
	}

	tx := Transaction{
		Ticker:      ticker,
		PriceAtTime: price,
		UserID:      user.ID,
		Type:        Sell,
		Quantity:    quantity,
	}
	if err := CreateTransaction(tx, user.db); err != nil {
		return tx, err
	}

	if err := user.db.Model(&user).Update("funds", user.Funds+(float64(quantity)*price)).Error; err != nil {
		return Transaction{}, err
	}

	return tx, nil
}

func (user *User) GetPortfolioValue() (float64, error) {
	var value float64 = 0

	stockMap, err := StockMap(user.ID, user.db)
	if err != nil {
		return 0, err
	}

	for ticker, quantity := range stockMap {
		price, _, err := stocks.GetCurrentPrice(ticker)
		if err != nil {
			return 0, err
		}
		value += price * float64(quantity)
	}

	value += float64(user.Funds)

	return value, nil
}

func (user *User) GetTransactions() ([]Transaction, error) {
	var txs []Transaction

	if err := user.db.Model(&user).Related(&txs).Error; err != nil {
		return txs, err
	}

	return txs, nil
}
