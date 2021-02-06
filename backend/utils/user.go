package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
)

func GetUser(username string, c *fiber.Ctx, user *models.User) {
	collection, err := GetMongoDbCollection("users")

	if username == "" || err != nil {
		return
	}

	filter := bson.M{"username": username}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(user)
}
