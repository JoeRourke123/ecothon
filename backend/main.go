package main

import (
	"ecothon/router"
	"log"

	"github.com/gofiber/fiber"
)

const port string = ":3000"

func main() {
	app := fiber.New()

	router.SetupRoutes(app)

	log.Fatal(app.Listen(port))
}
