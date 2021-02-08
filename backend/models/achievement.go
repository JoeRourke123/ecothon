package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Achievement struct {
	ID              primitive.ObjectID `json:"id" bson:"_id"`
	Title           string             `json:"title" bson:"title"`
	Description     string             `json:"description" bson:"description"`
	CarbonReduction float32            `json:"carbon_reduction" bson:"carbon_reduction"`
	Repeating       bool               `json:"repeating" bson:"repeating"`
	Points          int32              `json:"points" bson:"points"`
	AchievedBy      []bson.M           `json:"achieved_by" bson:"achieved_by"`
	Details         bson.M             `json:"details" bson:"details"`
	Image           string             `json:"image" bson:"image"`
}

type SimpleAchievement struct {
	ID              primitive.ObjectID `json:"id" bson:"_id"`
	Title           string             `json:"title" bson:"title"`
	Description     string             `json:"description" bson:"description"`
	CarbonReduction float32            `json:"carbon_reduction" bson:"carbon_reduction"`
	Repeating       bool               `json:"repeating" bson:"repeating"`
	Points          int32              `json:"points" bson:"points"`
	Image           string             `json:"image" bson:"image"`
}
