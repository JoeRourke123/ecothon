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
					{"$in", user.Achievements },
				},
			},
		})

		if cur == nil {
			return fiber.ErrBadRequest
		}

		var results []bson.D
		defer cur.Close(c.Context())

		cur.All(c.Context(), &results)
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
				{"$nin", user.Achievements },
			},
		},
	})

	if cur == nil {
		return fiber.ErrBadRequest
	}

	var results []bson.D
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)
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

	var results []bson.D
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)
	return c.JSON(results)
}
//
//func DoAchievement(c *fiber.Ctx) {
//	collection, err := utils.GetMongoDbCollection("achievements")
//	token := c.Locals("user").(*jwt.Token)
//	var user models.User
//	utils.GetUser(string(token.Header["user_id"]), c, &user)
//}
