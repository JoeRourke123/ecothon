package models

import (
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type AchievementUser struct {
	User       primitive.ObjectID `json:"user"  bson:"user"`
	AchievedAt time.Time          `json:"achieved_at"  bson:"achieved_at"`
	Post       primitive.ObjectID `json:"post"  bson:"post"`
}

type SerialisedAchievementUser struct {
	User       SerialisedUser     `json:"user"  bson:"user"`
	AchievedAt time.Time          `json:"achieved_at"  bson:"achieved_at"`
	Post       primitive.ObjectID `json:"post"  bson:"post"`
}

type Achievement struct {
	ID              primitive.ObjectID `json:"id" bson:"_id"`
	Title           string             `json:"title" bson:"title"`
	CarbonReduction float32            `json:"carbon_reduction" bson:"carbon_reduction"`
	Repeating       bool               `json:"repeating" bson:"repeating"`
	Points          int32              `json:"points" bson:"points"`
	AchievedBy      []AchievementUser  `json:"achieved_by" bson:"achieved_by"`
	Details         bson.M             `json:"details" bson:"details"`
	Image           string             `json:"image" bson:"image"`
}

type SerialisedAchievement struct {
	ID              primitive.ObjectID `json:"id" bson:"_id"`
	Title           string             `json:"title" bson:"title"`
	CarbonReduction float32            `json:"carbon_reduction" bson:"carbon_reduction"`
	Repeating       bool               `json:"repeating" bson:"repeating"`
	Points          int32              `json:"points" bson:"points"`
	Image           string             `json:"image" bson:"image"`
	AchievedCount   int16              `json:"achievement_count"  bson:"achievement_count"`
	Completed       bool               `json:"completed"  bson:"completed"`
}
