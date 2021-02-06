package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func GetUser(id string, c *fiber.Ctx, user *models.User) {
	collection, err := GetMongoDbCollection("users")

	if id == "" || err != nil {
		return
	}

	objID, _ := primitive.ObjectIDFromHex(id)
	filter := bson.M{"_id": objID}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(user)
}
