package middleware

import (
	"github.com/gofiber/fiber"
	jwtware "github.com/gofiber/jwt"
)

// Protected protect routes
func Protected() fiber.Handler {
	return jwtware.New(jwtware.Config{
		SigningKey:   []byte("secret"),
		ErrorHandler: jwtError,
	})
}

func jwtError(c *fiber.Ctx, err error) {
	c.SendStatus(403)
}
