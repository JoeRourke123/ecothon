package router

import (
	"ecothon/endpoints"
	"ecothon/middleware"

	"github.com/gofiber/fiber"
)

// SetupRoutes setup router api
func SetupRoutes(app *fiber.App) {
	/// API
	api := app.Group("/api")

	//// Auth
	auth := api.Group("/auth")
	auth.Post("/create-user", endpoints.CreateUser)

	/// Feed
	posts := api.Group("/posts")
	posts.Post("/", middleware.Protected(), endpoints.GetFeed)

	achievements := api.Group("/achievements")
	achievements.Get("/completed", middleware.Protected(), endpoints.GetCompletedAchievements)

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
