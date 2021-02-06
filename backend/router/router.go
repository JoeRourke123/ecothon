package router

import (
	"ecothon/endpoints"

	"github.com/gofiber/fiber"
)

// SetupRoutes setup router api
func SetupRoutes(app *fiber.App) {
	//// Auth
	auth := app.Group("/auth")
	auth.Post("/create-user", endpoints.CreateUser)
	// Middleware
	// api := app.Group("/api")

	print("Hello")

	//// Auth
	//auth := api.Group("/auth")
	//auth.Post("/login", handler.Login)
	//
	//// Products
	//product := api.Group("/product")
	//product.Get("/", handler.GetAllProducts)
	//product.Get("/:id", handler.GetProduct)
	//product.Post("/", middleware.Protected(), handler.CreateProduct)
	//product.Delete("/:id", middleware.Protected(), handler.DeleteProduct)
}
