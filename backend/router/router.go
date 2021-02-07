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

	api.Get("/user/:username/profile", middleware.Auth, endpoints.UserProfile)

	//// Auth
	auth := api.Group("/auth")
	auth.Post("/create-user", endpoints.CreateUser)
	auth.Post("/login", endpoints.LoginUser)

	/// Feed
	posts := api.Group("/posts")
	posts.Post("", middleware.Auth, endpoints.GetFeed)
	posts.Post("/create", middleware.Auth, endpoints.CreatePost)

	achievements := api.Group("/achievements")
	achievements.Get("/complete", middleware.Auth, endpoints.GetCompletedAchievements)
	achievements.Get("/incomplete", middleware.Auth, endpoints.GetIncompletedAchievements)
	achievements.Get("/all", middleware.Auth, endpoints.GetAllAchievements)
	achievements.Post("/:id/done", middleware.Auth, endpoints.DoAchievement)

	//// Upload image
	upload := api.Group("/upload")
	upload.Post("/generate-url", middleware.Auth, endpoints.CreateUploadURL)

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
