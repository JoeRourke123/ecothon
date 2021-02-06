package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type Location struct {
	Type        string    `json:"type" bson:"type"`
	Coordinates []float64 `json:"coordinates" bson:"coordinates"`
}

type Post struct {
	_id         primitive.ObjectID   `json:"id,omitempty"`
	User        primitive.ObjectID   `json:"user"`
	Achievement primitive.ObjectID   `json:"achievement,omitempty"`
	Type        string               `json:"type,omitempty"`
	Comments    []bson.M             `json:"comments,omitempty"`
	LikedBy     []primitive.ObjectID `json:"liked_by"`
	Geolocation Location             `json:"geolocation"`
	Details     bson.M               `json:"details,omitempty"`
	CreatedAt   time.Time            `json:"created_at,omitempty"`
}
