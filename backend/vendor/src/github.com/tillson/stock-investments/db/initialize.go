package db

import (
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/tillson/stock-investments/config"
	"github.com/tillson/stock-investments/models"
)

func Initialize() (*gorm.DB, error) {
	db, err := gorm.Open("postgres", config.DB)
	if err != nil {
		return nil, err
	}

	db.AutoMigrate(&models.User{})

	return db, nil
}
