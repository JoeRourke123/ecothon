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
		post.Comments = []models.Comment{}
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

func LikePost(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	id, _ := primitive.ObjectIDFromHex(c.Params("id"))

	collection, err := utils.GetMongoDbCollection(c, "posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	_, err = collection.UpdateOne(c.Context(), bson.D{
		{"_id", id},
	}, bson.D{
		{
			"$push", bson.D{
			{"likedby", bson.D{
				{"$each", bson.A{username}},
				{"$sort", 1},
			}},
		},
		},
	})

	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	return c.SendStatus(fiber.StatusOK)
}

func UnlikePost(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	id, _ := primitive.ObjectIDFromHex(c.Params("id"))

	collection, err := utils.GetMongoDbCollection(c, "posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	_, err = collection.UpdateOne(c.Context(), bson.D{
		{"_id", id},
	}, bson.D{
		{
			"$pull", bson.D{
			{"likedby", username},
		},
		},
	})

	return c.SendStatus(fiber.StatusOK)
}

func CommentPost(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	id, _ := primitive.ObjectIDFromHex(c.Params("id"))

	var comment models.Comment
	json.Unmarshal(c.Body(), &comment)
	comment.User = username
	comment.CommentedAt = time.Now()

	collection, err := utils.GetMongoDbCollection(c, "posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	collection.UpdateOne(c.Context(), bson.M{
		"_id": id,
	}, bson.M{
		"$push": bson.M{
			"comments": comment,
		},
	})

	return c.SendStatus(fiber.StatusOK)
}
