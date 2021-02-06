package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	_id            primitive.ObjectID   `json:"id,omitempty"`
	FirstName      string               `json:"first_name,omitempty"`
	LastName       string               `json:"last_name,omitempty"`
	Username       string               `json:"username,omitempty"`
	Email          string               `json:"email,omitempty"`
	Password       string               `json:"password,omitempty,secret"`
	LikedPosts     []primitive.ObjectID `json:"liked_posts"`
	Achievements   []primitive.ObjectID `json:"achievements"`
	Points         int16                `json:"points"`
	StartingCarbon float32              `json:"carbon_estimate,omitempty"`
	CurrentCarbon  float32              `json:"current_estimate,omitempty"`
	AccountCreated time.Time            `json:"account_created,omitempty"`
	Followers      []string             `json:"followers,omitempty"`
	Following      []string             `json:"following,omitempty"`
	IsSecret       bool                 `json:"is_secret,omitempty"`
}
