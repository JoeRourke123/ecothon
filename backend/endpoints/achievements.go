package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"github.com/gofiber/fiber"
	"go.mongodb.org/mongo-driver/bson"
)


func GetCompletedAchievements(c *fiber.Ctx) {
		var user models.User
		utils.GetUser(c.Params("id"), c, &user)

		collection, err := utils.GetMongoDbCollection("achievements")

		if err != nil {
			c.SendStatus(500)
			return
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
			c.SendStatus(400)
			return
		}

		var results []bson.D
		defer cur.Close(c.Context())

		cur.All(c.Context(), &results)
		data, _ := json.Marshal(results)
		c.Send(data)
}

func GetIncompletedAchievements(c *fiber.Ctx) {
	var user models.User
	utils.GetUser(c.Params("id"), c, &user)

	collection, err := utils.GetMongoDbCollection("achievements")

	if err != nil {
		c.SendStatus(500)
		return
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
		c.SendStatus(400)
		return
	}

	var results []bson.D
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)
	data, _ := json.Marshal(results)
	c.Send(data)
}

func GetAllAchievements(c *fiber.Ctx) {
	collection, err := utils.GetMongoDbCollection("achievements")

	if err != nil {
		c.SendStatus(500)
		return
	}

	cur, err := collection.Find(c.Context(), bson.D{
	})

	if cur == nil {
		c.SendStatus(400)
		return
	}

	var results []bson.D
	defer cur.Close(c.Context())

	cur.All(c.Context(), &results)
	data, _ := json.Marshal(results)
	c.Send(data)
}
