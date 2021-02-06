package main

import (
	"ecothon/router"
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/logger"
)

const port string = "0.0.0.0:3000"

func main() {
	app := fiber.New()

	app.Use(logger.New())
	app.Use(compress.New())

	router.SetupRoutes(app)

	log.Fatal(app.Listen(port))
}
