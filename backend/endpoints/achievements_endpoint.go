package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

func GetAllAchievements(c *fiber.Ctx) error {
	var user models.User
	userID := c.Locals("USER").(primitive.ObjectID)
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
		err := cur.Decode(&achievement)
		if err != nil {
			print(err.Error())
		}

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

	achievementIDs := make([]primitive.ObjectID, len(user.Achievements))
	for i, item := range user.Achievements {
		achievementIDs[i] = item.Achievement
	}

	cur, _ := collection.Find(c.Context(), bson.M{
		"_id": bson.M{
			"$in": achievementIDs,
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

func GetIncompleteAchievements(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "achievements")

	if err != nil {
		return fiber.ErrInternalServerError
	}

	achievementIDs := make([]primitive.ObjectID, len(user.Achievements))
	for i, item := range user.Achievements {
		achievementIDs[i] = item.Achievement
	}

	cur, _ := collection.Find(c.Context(), bson.M{
		"_id": bson.M{
			"$nin": achievementIDs,
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

	achievementID, err := primitive.ObjectIDFromHex(c.Params("id"))
	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	achievementUser := models.AchievementUser{User: userID, AchievedAt: now}

	_, err = collection.UpdateOne(c.Context(), bson.M{
		"_id": achievementID,
	}, bson.M{
		"$push": bson.M{
			"achieved_by": bson.M{
				"$each": bson.A{achievementUser},
				"$sort": bson.M{
					"achieved_by.user": 1,
				},
			},
		},
	})


	if err != nil {
		print(err.Error())
		return fiber.ErrBadRequest
	}

	var achievement models.Achievement
	utils.GetAchievement(achievementID, c, &achievement)

	userAchievement := models.UserAchievement{
		Achievement: achievementID,
		AchievedAt: now,
	}
	err = utils.AddUserAchievement(user, c, &achievement, userAchievement)
	if err != nil {
		print(err.Error())
	}

	serialised := utils.GetSerialisedAchievement(&achievement, &user)

	return c.JSON(serialised)
}
