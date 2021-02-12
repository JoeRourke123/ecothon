package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func GetUser(id primitive.ObjectID, c *fiber.Ctx, user *models.User) {
	collection, err := GetMongoDbCollection(c, "users")

	if id.IsZero() || err != nil {
		return
	}

	filter := bson.M{"_id": id}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(user)
}

func GetAchievement(id primitive.ObjectID, c *fiber.Ctx, achievement *models.Achievement) {
	collection, err := GetMongoDbCollection(c, "achievements")

	if id.IsZero() || err != nil {
		return
	}

	filter := bson.M{"_id": id}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(achievement)
}

func GetPost(id primitive.ObjectID, c *fiber.Ctx, post *models.Post) {
	collection, err := GetMongoDbCollection(c, "posts")

	if id.IsZero() || err != nil {
		return
	}

	filter := bson.M{"_id": id}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(post)
}
