package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	_id            primitive.ObjectID   `json:"id"`
	FirstName      string               `json:"first_name"`
	LastName       string               `json:"last_name"`
	Username       string               `json:"username"`
	Email          string               `json:"email"`
	Password       string               `json:"password,secret"`
	Achievements   []bson.M `json:"achievements"`
	Points         int16                `json:"points"`
	StartingCarbon float32              `json:"carbon_estimate"`
	CurrentCarbon  float32              `json:"current_estimate"`
	AccountCreated time.Time            `json:"account_created"`
	Followers      []string             `json:"followers"`
	Following      []string             `json:"following"`
	IsSecret       bool                 `json:"is_secret"`
}
