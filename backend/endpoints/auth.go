package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"

	"github.com/gofiber/fiber"
)

func CreateUser(c *fiber.Ctx) {
	collection, err := utils.GetMongoDbCollection("users")
	if err != nil {
		c.Status(500).Send(err)
		return
	}

	var user models.User
	json.Unmarshal([]byte(c.Body()), &user)

	res, err := collection.InsertOne(context.Background(), user)
	if err != nil {
		c.Status(500).Send(err)
		return
	}

	response, _ := json.Marshal(res)
	c.Send(response)
}
