package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
)

func GetCompletedAchievements(c *fiber.Ctx) error {
	var user models.User
	var user_id string = c.Locals("USER").(string)
	utils.GetUser(user_id, c, &user)

	collection, err := utils.GetMongoDbCollection("achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	cur, err := collection.Find(c.Context(), bson.D{
		{
			"_id",
			bson.D{
				{"$in", user.Achievements},
			},
		},
	})

	if cur == nil {
		return fiber.ErrBadRequest
	}

	var results []bson.M
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)

	if results == nil {
		results = make([]bson.M, 0)
	}
	return c.JSON(results)
}

func GetIncompletedAchievements(c *fiber.Ctx) error {
	var user models.User
	var user_id string = c.Locals("USER").(string)
	utils.GetUser(user_id, c, &user)

	collection, err := utils.GetMongoDbCollection("achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	cur, err := collection.Find(c.Context(), bson.D{
		{
			"_id",
			bson.D{
				{"$nin", user.Achievements},
			},
		},
	})

	if cur == nil {
		return fiber.ErrBadRequest
	}

	var results []bson.M
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)

	if results == nil {
		results = make([]bson.M, 0)
	}

	return c.JSON(results)
}

func GetAllAchievements(c *fiber.Ctx) error {
	collection, err := utils.GetMongoDbCollection("achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	cur, err := collection.Find(c.Context(), bson.D{
	})

	if cur == nil {
		return fiber.ErrBadRequest
	}

	var results []bson.M
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)

	if results == nil {
		results = make([]bson.M, 0)
	}

	return c.JSON(results)
}
