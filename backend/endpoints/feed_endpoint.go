package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"go.mongodb.org/mongo-driver/bson/primitive"

	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

const MAX_DISTANCE int = 1000000

func GetFeed(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

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
	options.SetSort(bson.D{{"created_at", -1}})
	options.SetLimit(50)

	cur, err := collection.Find(c.Context(), filter, options)

	if err != nil {
		print(err.Error())
		return fiber.ErrInternalServerError
	}
	if cur != nil {
		defer cur.Close(c.Context())
	}

	returnData := make([]models.SerialisedPost, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var post models.Post
		cur.Decode(&post)

		post.ID = cur.Current.Index(0).Value().ObjectID()
		post.IsLiked = utils.BinarySearch(post.LikedBy, userID)

		var ach models.Achievement
		utils.GetAchievement(post.Achievement, c, &ach)

		var poster models.User
		utils.GetUser(post.User, c, &poster)

		simpleUser := utils.GetSerialisedUser(&poster, &user)
		simpleAchievement := utils.GetSerialisedAchievement(&ach, &user)

		returnData[i] = utils.GetSerialisedPost(&post, &simpleAchievement, &simpleUser, &user)
		i++
	}

	return c.JSON(returnData)
}

func GetAllPoints(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

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
