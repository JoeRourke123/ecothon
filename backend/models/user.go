package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID            primitive.ObjectID `json:"id" bson:"_id"`
	FirstName      string             `json:"first_name" bson:"first_name"`
	LastName       string             `json:"last_name" bson:"last_name"`
	Username       string             `json:"username" bson:"username"`
	ProfilePicture string             `json:"profile_picture" bson:"profile_picture"`
	Email          string             `json:"email" bson:"email"`
	Password       string             `json:"password,secret" bson:"password"`
	Achievements   []bson.M           `json:"achievements" bson:"achievements"`
	Points         int16              `json:"points" bson:"points"`
	StartingCarbon float32            `json:"carbon_estimate" bson:"carbon_estimate"`
	CurrentCarbon  float32            `json:"current_estimate" bson:"current_estimate"`
	AccountCreated time.Time          `json:"account_created" bson:"account_created"`
	Followers      []string           `json:"followers" bson:"followers"`
	Following      []string           `json:"following" bson:"following"`
	IsSecret       bool               `json:"is_secret" bson:"is_secret"`
}

type SimpleUser struct {
	ID            primitive.ObjectID `json:"id" bson:"_id"`
	FirstName      string             `json:"first_name" bson:"first_name"`
	LastName       string             `json:"last_name" bson:"last_name"`
	Username       string             `json:"username" bson:"username"`
	ProfilePicture string             `json:"profile_picture" bson:"profile_picture"`
	Email          string             `json:"email" bson:"email"`
	Points         int16              `json:"points" bson:"points"`
	IsSecret       bool               `json:"is_secret" bson:"is_secret"`
}
