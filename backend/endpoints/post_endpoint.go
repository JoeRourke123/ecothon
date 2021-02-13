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
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	now := time.Now()

	collection, err := utils.GetMongoDbCollection(c, "posts")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	var post models.Post
	json.Unmarshal([]byte(c.Body()), &post)

	post.ID = primitive.NewObjectID()
	post.Geolocation.Type = "Point"
	post.CreatedAt = now
	post.User = userID

	if post.Comments == nil {
		post.Comments = []models.Comment{}
	}
	if post.LikedBy == nil {
		post.LikedBy = []primitive.ObjectID{}
	}

	res, err := collection.InsertOne(c.Context(), post)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	if post.Achievement != primitive.NilObjectID {
		var achievement models.Achievement
		utils.GetAchievement(post.Achievement, c, &achievement)

		userAchievement := models.UserAchievement{
			AchievedAt:  time.Now(),
			Achievement: achievement.ID,
			Post:        post.ID,
		}

		err := utils.AddUserAchievement(user, c, &achievement, userAchievement)

		if err != nil {
			return err
		}
	}

	return c.JSON(res)
}

func LikePost(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

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
			{"liked_by", bson.D{
				{"$each", bson.A{userID}},
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
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

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
			{"liked_by", userID},
		},
		},
	})

	return c.SendStatus(fiber.StatusOK)
}

func CommentPost(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	id, _ := primitive.ObjectIDFromHex(c.Params("id"))

	var comment models.Comment
	json.Unmarshal(c.Body(), &comment)
	comment.User = userID
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
