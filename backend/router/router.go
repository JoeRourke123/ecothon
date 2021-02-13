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

	user := api.Group("/user")
	user.Get("/user/:id/profile", middleware.Auth, endpoints.UserProfile)
	user.Post("/user/:id/follow", middleware.Auth, endpoints.UserFollow)
	user.Put("/user/profile-picture", middleware.Auth, endpoints.SetProfilePicture)
	user.Post("/create", endpoints.CreateUser)
	user.Post("/login", endpoints.LoginUser)

	/// Feed
	posts := api.Group("/posts")
	posts.Post("", middleware.Auth, endpoints.GetFeed)
	posts.Get("/all-points", middleware.Auth, endpoints.GetAllPoints)
	posts.Post("/create", middleware.Auth, endpoints.CreatePost)
	posts.Post("/:id/like", middleware.Auth, endpoints.LikePost)
	posts.Post("/:id/unlike", middleware.Auth, endpoints.UnlikePost)
	posts.Post("/:id/comment", middleware.Auth, endpoints.CommentPost)

	achievements := api.Group("/achievements")
	achievements.Get("/complete", middleware.Auth, endpoints.GetCompletedAchievements)
	achievements.Get("/incomplete", middleware.Auth, endpoints.GetIncompleteAchievements)
	achievements.Get("/all", middleware.Auth, endpoints.GetAllAchievements)
	achievements.Post("/:id/done", middleware.Auth, endpoints.DoAchievement)

	leaderboard := api.Group("/leaderboard")
	leaderboard.Get("", middleware.Auth, endpoints.AllLeaderboard)
	leaderboard.Get("/following", middleware.Auth, endpoints.FollowingLeaderboard)

	//// Upload image
	upload := api.Group("/upload")
	upload.Post("/generate-url", middleware.Auth, endpoints.CreateUploadURL)
	upload.Post("/image", middleware.Auth, endpoints.UploadImage)

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
