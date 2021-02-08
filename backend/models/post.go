package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type Location struct {
	Type        string `json:"type" bson:"type"`
	Coordinates bson.A `json:"coordinates" bson:"coordinates"`
}

type Comment struct {
	User        string    `json:"user"  bson:"user"`
	Comment     string    `json:"comment"  bson:"comment"`
	CommentedAt time.Time `json:"commented_at" bson:"commented_at"`
}

type Post struct {
	ID          primitive.ObjectID `json:"id" bson:"_id"`
	User        string             `json:"user" bson:"user"`
	Picture     string             `json:"picture" bson:"picture"`
	Achievement primitive.ObjectID `json:"achievement" bson:"achievement"`
	Type        string             `json:"type" bson:"type"`
	Comments    []Comment          `json:"comments" bson:"comments"`
	LikedBy     []string           `json:"liked_by" bson:"liked_by"`
	Geolocation Location           `json:"geolocation" bson:"geolocation"`
	Details     bson.M             `json:"details" bson:"details"`
	CreatedAt   time.Time          `json:"created_at" bson:"created_at"`
}

type SimplePost struct {
	ID          primitive.ObjectID `json:"id" bson:"_id"`
	User        string             `json:"user" bson:"user"`
	Picture     string             `json:"picture" bson:"picture"`
	Achievement Achievement        `json:"achievement" bson:"achievement"`
	Type        string             `json:"type" bson:"type"`
	LikeCount   int16              `json:"like_count" bson:"like_count"`
	Geolocation Location           `json:"geolocation" bson:"geolocation"`
	Details     bson.M             `json:"details" bson:"details"`
	CreatedAt   time.Time          `json:"created_at" bson:"created_at"`
}
