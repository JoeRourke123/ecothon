package models

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type User struct {
	_id            primitive.ObjectID   `json:"id,omitempty"`
	FirstName      string               `json:"firstname,omitempty"`
	LastName       string               `json:"lastname,omitempty"`
	Email          string               `json:"email,omitempty"`
	Password       string               `json:"password,omitempty,secret"`
	LikedPosts     []primitive.ObjectID `json:"liked_posts"`
	Achievements   []primitive.ObjectID `json:"achievements"`
	StartingCarbon float32              `json:"carbon_estimate,omitempty"`
	CurrentCarbon  float32              `json:"current_estimate,omitempty"`
	AccountCreated time.Time            `json:"account_created,omitempty"`
}

