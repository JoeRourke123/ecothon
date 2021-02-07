package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

func AllLeaderboard(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "users")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	findOptions := options2.Find()
	findOptions.SetSort(bson.M{ "points": -1 })
	findOptions.SetLimit(20)

	cur, err := collection.Find(c.Context(), bson.M{}, findOptions)

	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	results := make([]models.User, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		cur.Decode(&(results[i]))
		i++
	}

	cur.Close(c.Context())

	return c.JSON(results)
}

func FollowingLeaderboard(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "users")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	findOptions := options2.Find()
	findOptions.SetSort(bson.M{ "points": -1 })

	cur, err := collection.Find(c.Context(), bson.M{
		"username": bson.M{
			"$in": user.Following,
		},
	}, findOptions)

	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	results := make([]models.User, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		cur.Decode(&(results[i]))
		i++
	}

	cur.Close(c.Context())

	return c.JSON(results)
}
