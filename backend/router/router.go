package router

import (
	"ecothon/endpoints"
	"ecothon/middleware"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/limiter"
)

// SetupRoutes setup router api
func SetupRoutes(app *fiber.App) {
	// Request limiter
	limit := limiter.New(limiter.Config{
		Max:        5,
		Expiration: 1 * time.Minute,
		KeyGenerator: func(c *fiber.Ctx) string {
			return c.IP()
		},
		LimitReached: func(c *fiber.Ctx) error {
			return c.Status(429).JSON(map[string]string{"error": "Please make requests less often."})
		},
	})

	/// API
	api := app.Group("/api")

	api.Get("/user/:username/profile", middleware.Auth, endpoints.UserProfile)
	api.Post("/user/:username/follow", middleware.Auth, endpoints.UserFollow)
	api.Put("/user/profile-picture", middleware.Auth, endpoints.SetProfilePicture)

	//// Auth
	auth := api.Group("/auth")
	auth.Post("/create-user", endpoints.CreateUser)
	auth.Post("/login", endpoints.LoginUser)

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
	achievements.Get("/incomplete", middleware.Auth, endpoints.GetIncompletedAchievements)
	achievements.Get("/all", middleware.Auth, endpoints.GetAllAchievements)
	achievements.Post("/:id/done", middleware.Auth, endpoints.DoAchievement)

	leaderboard := api.Group("/leaderboard")
	leaderboard.Get("", middleware.Auth, endpoints.AllLeaderboard)
	leaderboard.Get("/following", middleware.Auth, endpoints.FollowingLeaderboard)

	//// Upload image
	upload := api.Group("/upload")
	// upload.Post("/generate-url", middleware.Auth, endpoints.CreateUploadURL) // currently broken
	upload.Post("/image", limit, middleware.Auth, endpoints.UploadImage)

}
