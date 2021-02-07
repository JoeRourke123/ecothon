package endpoints

import (
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
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	now := time.Now()

	collection, err := utils.GetMongoDbCollection(c, "posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	var post models.Post
	json.Unmarshal([]byte(c.Body()), &post)

	post.Geolocation.Type = "Point"
	post.CreatedAt = now

	if post.Comments == nil {
		post.Comments = []bson.M{}
	}
	if post.LikedBy == nil {
		post.LikedBy = []string{}
	}

	res, err := collection.InsertOne(c.Context(), post)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	if post.Achievement != primitive.NilObjectID {
		err = utils.AddUserAchievement(username, res.InsertedID.(primitive.ObjectID), post.Achievement, c, now)

		if err != nil {
			return err
		}
	}

	return c.JSON(res)
}
