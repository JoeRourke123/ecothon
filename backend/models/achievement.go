package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Achievement struct {
	_id             primitive.ObjectID `json:"id,omitempty"`
	Title           string             `json:"title"`
	Description     string             `json:"description"`
	CarbonReduction float32            `json:"carbon_reduction"`
	Repeating       bool               `json:"repeating"`
	Points          int32               `json:"points"`
	AchievedBy      []bson.M           `json:"achieved_by"`
	Details         bson.M             `json:"details"`
	ImageURL		string				`json:"image_url"`
}
