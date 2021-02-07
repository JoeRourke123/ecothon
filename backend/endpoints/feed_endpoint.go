package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

const MAX_DISTANCE int = 1000000

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
		"geolocation": bson.M{
			"$nearSphere": bson.M{
				"$geometry":    loc,
				"$maxDistance": MAX_DISTANCE},
		},
	}

	options := options2.Find()
	options.SetSort(bson.D{{"createdat", -1}})
	options.SetLimit(50)

	cur, err := collection.Find(c.Context(), filter, options)

	if err != nil {
		print(err.Error())
		return fiber.ErrInternalServerError
	}
	if cur != nil {
		defer cur.Close(c.Context())
	}

	achievementsCollection, err := utils.GetMongoDbCollection(c, "achievements")
	if err != nil {
		print(err.Error())
		return fiber.ErrInternalServerError
	}

	returnData := make([]models.ReturnPost, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var r models.ReturnPost
		cur.Decode(&r)

		r.ID = cur.Current.Index(0).Value().ObjectID()
		r.IsLiked = utils.BinarySearch(r.LikedBy, username)

		aCur := achievementsCollection.FindOne(c.Context(), bson.D{
			{"_id", r.Achievement},
		})
		aCur.Decode(&r.AchievementObj)

		returnData[i] = r
		i++
	}

	return c.JSON(returnData)
}

func GetAllPoints(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "posts")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	filter := bson.M{}

	cur, err := collection.Find(c.Context(), &filter)

	len := cur.RemainingBatchLength()

	returnData := make([]models.Location, len)

	for i := 0; i < len; i++ {
		cur.Next(c.Context())

		var p models.Post
		cur.Decode(&p)

		returnData[i] = p.Geolocation
	}

	return c.JSON(returnData)
}
