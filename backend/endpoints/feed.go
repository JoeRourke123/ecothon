package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

const MAX_DISTANCE int = 10000

func GetFeed(c *fiber.Ctx) error {
	collection, err := utils.GetMongoDbCollection("posts")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var loc models.Location
	json.Unmarshal([]byte(c.Body()), &loc)

	filter := bson.D{
		{"location",
			bson.D{
				{"$near", bson.D{
					{"$geometry", loc},
					{"$maxDistance", MAX_DISTANCE},
				}},
			}},
		{

		},
	}

	options := options2.Find()
	options.SetSort(bson.D{{"created_at", -1}})
	options.SetLimit(50)

	var results []bson.M
	cur, err := collection.Find(c.Context(), filter, options)

	if err != nil {
		return fiber.ErrInternalServerError
	}
	if cur != nil {
		defer cur.Close(c.Context())
	}

	cur.All(c.Context(), &results)

	if results == nil {
		return fiber.ErrNotFound
	}

	return c.JSON(results)
}
