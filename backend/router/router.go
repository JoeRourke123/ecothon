package router

import (
	"ecothon/endpoints"
	"ecothon/middleware"

	"github.com/gofiber/fiber/v2"
)

// SetupRoutes setup router api
func SetupRoutes(app *fiber.App) {
	/// API
	api := app.Group("/api")

	//// Auth
	auth := api.Group("/auth")
	auth.Post("/create-user", endpoints.CreateUser)
	auth.Post("/login", endpoints.LoginUser)

	/// Feed
	posts := api.Group("/posts")
	posts.Post("", middleware.Auth, endpoints.GetFeed)
	//posts.Post("/new-post", middleware.Protected(), endpoints.NewPost)

	achievements := api.Group("/achievements")
	achievements.Get("/complete", middleware.Auth, endpoints.GetCompletedAchievements)
	achievements.Get("/incomplete", middleware.Auth, endpoints.GetIncompletedAchievements)
	achievements.Get("/all", middleware.Auth, endpoints.GetAllAchievements)
	achievements.Post("/:id/done", middleware.Auth, endpoints.DoAchievement)

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
