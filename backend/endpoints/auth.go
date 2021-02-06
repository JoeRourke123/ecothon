package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"

	"github.com/gofiber/fiber/v2"
)

func CreateUser(c *fiber.Ctx) error {
	collection, err := utils.GetMongoDbCollection("users")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var user models.User
	json.Unmarshal([]byte(c.Body()), &user)

	res, err := collection.InsertOne(context.Background(), user)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	return c.JSON(res)
}
