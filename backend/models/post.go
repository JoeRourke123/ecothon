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
	User        string    `json:"user,omitempty"`
	Comment     string    `json:"comment,omitempty"`
	CommentedAt time.Time `json:"commented_at,omitempty"`
}

type Post struct {
	_id         primitive.ObjectID `json:"id,omitempty"`
	User        string             `json:"user"`
	Picture     string             `json:"picture,omitempty"`
	Achievement primitive.ObjectID `json:"achievement,omitempty"`
	Type        string             `json:"type,omitempty"`
	Comments    []Comment          `json:"comments,omitempty"`
	LikedBy     []string           `json:"liked_by"`
	Geolocation Location           `json:"geolocation"`
	Details     bson.M             `json:"details,omitempty"`
	CreatedAt   time.Time          `json:"created_at,omitempty"`
}

type ReturnPost struct {
	ID            primitive.ObjectID `json:"_id"`
	User           string             `json:"user"`
	Picture        string             `json:"picture"`
	AchievementObj bson.M        `json:"achievement"`
	Achievement    primitive.ObjectID `json:"achievement_id"`
	Type           string             `json:"type"`
	Comments       []Comment          `json:"comments"`
	LikedBy        []string           `json:"liked_by"`
	IsLiked        bool               `json:"is_liked"`
	Geolocation    Location           `json:"geolocation"`
	Details        bson.M             `json:"details"`
	CreatedAt      time.Time          `json:"created_at"`
}
