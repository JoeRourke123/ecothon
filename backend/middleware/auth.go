package middleware

import (
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"strings"
)

// Auth is the authentication middleware
func Auth(c *fiber.Ctx) error {
	h := c.Get("Authorization")

	if h == "" {
		return c.JSON(bson.M{"message": "Sorry, couldn't find your token"})
	}

	// Spliting the header
	chunks := strings.Split(h, " ")

	// If header signature is not like `Bearer <token>`, then throw
	// This is also required, otherwise chunks[1] will throw out of bound error
	if len(chunks) < 2 {
		return c.JSON(bson.M{"message": "Sorry, your token is not the correct format"})
	}

	// Verify the token which is in the chunks
	user, err := utils.Verify(chunks[1])

	if err != nil {
		print(err.Error())
		return c.JSON(bson.M{"message": "Sorry, your token could not be validated"})
	}

	c.Locals("USER", user.ID)

	return c.Next()
}
