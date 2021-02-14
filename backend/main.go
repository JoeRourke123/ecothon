package main

import (
	"ecothon/router"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/compress"
	"github.com/gofiber/fiber/v2/middleware/logger"
)

const port string = "localhost:4000"

func main() {
	app := fiber.New(
		fiber.Config{
			ServerHeader: "ecothon-server/1.0",
			BodyLimit:    10 * 1024 * 1024,
		})

	file, err := os.OpenFile("./ecothon.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	defer file.Close()

	app.Use(logger.New(logger.Config{
		Output: file,
	}), compress.New())

	app.Static("/", "./static")
	router.SetupRoutes(app)

	log.Fatal(app.Listen(port))
}
