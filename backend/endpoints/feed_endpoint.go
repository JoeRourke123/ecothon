package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

const MAX_DISTANCE int = 10000

func GetFeed(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

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

	for _, item := range results {
		item["is_liked"] = utils.BinarySearch(item["likedby"].([]string), username)

		id, _ := primitive.ObjectIDFromHex(item["achievement"].(string))

		cur, _ := collection.Find(c.Context(), bson.M{
			"_id": id,
		})
		var achievement models.Achievement
		cur.Decode(&achievement)

		item["achievement"] = achievement
	}

	if results == nil {
		return fiber.ErrNotFound
	}

	return c.JSON(results)
}
