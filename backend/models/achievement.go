package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Achievement struct {
	_id primitive.ObjectID `json:"id,omitempty"`
	Title	string `json:"title,omitempty"`
	CarbonReduction	float32 `json:"carbon_reduction,omitempty"`
	Repeating	bool `json:"repeating,omitempty"`
	Points	int8 `json:"points,omitempty"`
	AchievedBy []primitive.ObjectID `json:"achieved_by"`
	Details bson.M `json:"details,omitempty"`
}
