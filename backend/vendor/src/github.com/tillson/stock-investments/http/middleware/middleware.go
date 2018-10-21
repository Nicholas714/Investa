package middleware

import "github.com/jinzhu/gorm"

type Middleware struct {
	*gorm.DB
}

func New(dbM *gorm.DB) Middleware {
	return Middleware{dbM}
}
