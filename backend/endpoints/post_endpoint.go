package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"time"

	"encoding/json"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func CreatePost(c *fiber.Ctx) error {
	var user models.User
	var userID string = c.Locals("USER").(string)
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection("posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	var post models.Post
	json.Unmarshal([]byte(c.Body()), &post)

	post.Geolocation.Type = "Point"
	post.CreatedAt = time.Now()

	if post.Comments == nil {
		post.Comments = []bson.M{}
	}
	if post.LikedBy == nil {
		post.LikedBy = []primitive.ObjectID{}
	}

	res, err := collection.InsertOne(context.Background(), user)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	return c.JSON(res)
}
