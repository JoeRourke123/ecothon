package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

func AllLeaderboard(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

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

	results := make([]models.SerialisedUser, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var u models.User
		cur.Decode(&u)

		results[i] = utils.GetSerialisedUser(&u, &user)
		i++
	}

	cur.Close(c.Context())

	return c.JSON(results)
}

func FollowingLeaderboard(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "users")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	findOptions := options2.Find()
	findOptions.SetSort(bson.M{ "points": -1 })
	findOptions.SetLimit(50)

	cur, err := collection.Find(c.Context(), bson.M{
		"_id": bson.M{
			"$in": user.Following,
		},
	}, findOptions)

	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	results := make([]models.SerialisedUser, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var u models.User
		cur.Decode(&u)

		results[i] = utils.GetSerialisedUser(&u, &user)
		i++
	}

	cur.Close(c.Context())

	return c.JSON(results)
}
