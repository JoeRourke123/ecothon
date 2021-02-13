package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
	"time"
)

func GetAllAchievements(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	cur, _ := collection.Find(c.Context(), bson.M{})
	results := make([]models.SerialisedAchievement, cur.RemainingBatchLength())
	i := 0

	for cur.Next(c.Context()) {
		var achievement models.Achievement
		cur.Decode(&achievement)

		results[i] = utils.GetSerialisedAchievement(&achievement, &user)
		i++
	}

	return c.JSON(results)
}

func GetCompletedAchievements(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	options := options2.Find()
	options.SetSort(bson.M{ "achieved_by.achieved_at": 1 })

	cur, _ := collection.Find(c.Context(), bson.M{
		"achieved_by.user": userID,
	}, options)
	results := make([]models.SerialisedAchievement, cur.RemainingBatchLength())
	i := 0

	for cur.Next(c.Context()) {
		var achievement models.Achievement
		cur.Decode(&achievement)

		results[i] = utils.GetSerialisedAchievement(&achievement, &user)
		i++
	}

	return c.JSON(results)
}

func GetIncompleteAchievements(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	cur, _ := collection.Find(c.Context(), bson.M{
		"achieved_by.user": bson.M{
			"$ne": userID,
		},
	})
	results := make([]models.SerialisedAchievement, cur.RemainingBatchLength())
	i := 0

	for cur.Next(c.Context()) {
		var achievement models.Achievement
		cur.Decode(&achievement)

		results[i] = utils.GetSerialisedAchievement(&achievement, &user)
		i++
	}

	return c.JSON(results)
}

func DoAchievement(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	now := time.Now()

	collection, err := utils.GetMongoDbCollection(c, "achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	achievementID, _ := primitive.ObjectIDFromHex(c.Params("done"))
	achievementUser := models.AchievementUser{User: userID, AchievedAt: now }

	_, err = collection.UpdateOne(c.Context(), bson.M{
		"_id": achievementID,
	}, bson.M{
		"achieved_by": bson.M{
			"$push": bson.M{
				"$each": bson.A{ achievementUser },
				"$sort": bson.M{
					"achieved_by.user": 1,
				},
			},
		},
	})

	if err != nil {
		return fiber.ErrBadRequest
	}

	var achievement models.Achievement
	utils.GetAchievement(achievementID, c, &achievement)

	serialised := utils.GetSerialisedAchievement(&achievement, &user)

	return c.JSON(serialised)
}
