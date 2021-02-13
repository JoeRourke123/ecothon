package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type UserAchievement struct {
	AchievedAt  time.Time          `json:"achieved_at"  bson:"achieved_at"`
	Achievement primitive.ObjectID `json:"achievement"  bson:"achievement"`
	Post        primitive.ObjectID `json:"post"  bson:"post"`
}

type SerialisedUserAchievement struct {
	AchievedAt  time.Time             `json:"achieved_at"  bson:"achieved_at"`
	Achievement SerialisedAchievement `json:"achievement"  bson:"achievement"`
	Post        primitive.ObjectID    `json:"post"  bson:"post"`
}

type User struct {
	ID             primitive.ObjectID `json:"id" bson:"_id"`
	FirstName      string             `json:"first_name" bson:"first_name"`
	LastName       string             `json:"last_name" bson:"last_name"`
	Username       string             `json:"username" bson:"username"`
	ProfilePicture string             `json:"profile_picture" bson:"profile_picture"`
	Email          string             `json:"email" bson:"email"`
	Password       string             `json:"password,secret" bson:"password"`
	Achievements   []UserAchievement  `json:"achievements" bson:"achievements"`
	Points         int16              `json:"points" bson:"points"`
	StartingCarbon float64            `json:"carbon_estimate" bson:"carbon_estimate"`
	CurrentCarbon  float64            `json:"current_estimate" bson:"current_estimate"`
	AccountCreated time.Time          `json:"account_created" bson:"account_created"`
	Followers      []primitive.ObjectID           `json:"followers" bson:"followers"`
	Following      []primitive.ObjectID           `json:"following" bson:"following"`
	IsSecret       bool               `json:"is_secret" bson:"is_secret"`
}

type SerialisedUser struct {
	ID             primitive.ObjectID `json:"id" bson:"_id"`
	FirstName      string             `json:"first_name" bson:"first_name"`
	LastName       string             `json:"last_name" bson:"last_name"`
	Username       string             `json:"username" bson:"username"`
	ProfilePicture string             `json:"profile_picture" bson:"profile_picture"`
	Points         int16              `json:"points" bson:"points"`
	IsSecret       bool               `json:"is_secret" bson:"is_secret"`
	IsFollowing    bool               `json:"is_following" bson:"is_following"`
	StartingCarbon float64            `json:"carbon_estimate" bson:"carbon_estimate"`
	CurrentCarbon  float64            `json:"current_estimate" bson:"current_estimate"`
}
