package endpoints

import (
	"ecothon/utils"
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

const MAX_DISTANCE int = 10000

func GetFeed(c *fiber.Ctx) error {
	collection, err := utils.GetMongoDbCollection(c, "posts")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var loc bson.M
	json.Unmarshal([]byte(c.Body()), &loc)

	filter := bson.M{
		"geolocation":
		bson.M{
			"$nearSphere": bson.M{
				"$geometry": loc,
				"$maxDistance": MAX_DISTANCE},
		},
	}

	options := options2.Find()
	options.SetSort(bson.D{{"createdat", -1}})
	options.SetLimit(50)

	var results []bson.M
	cur, err := collection.Find(c.Context(), filter, options)

	if err != nil {
		print(err.Error())
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
