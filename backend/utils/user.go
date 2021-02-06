package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

func GetUser(username string, c *fiber.Ctx, user *models.User) {
	collection, err := GetMongoDbCollection("users")

	if username == "" || err != nil {
		return
	}

	filter := bson.M{"username": username}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(user)
}

func AddUserAchievement(username string, postID primitive.ObjectID,
	achievementID primitive.ObjectID, c *fiber.Ctx, now time.Time) error {
	achievementCol, err := GetMongoDbCollection("achievements")

	if err != nil {
		return err
	}

	_, err = achievementCol.UpdateOne(c.Context(),
		bson.D{{"_id", achievementID}},
		bson.D{{"$push", bson.D{{
			"achievedby", bson.M{
				"user":       username,
				"achievedAt": now,
				"post":       postID,
			},
		}}}})

	if err == nil {
		userCol, _ := GetMongoDbCollection("users")

		_, err = userCol.UpdateOne(c.Context(),
			bson.D{{"username", username}},
			bson.D{{"$push", bson.D{{
				"achievements", bson.M{
					"achievedAt":  now,
					"post":        postID,
					"achievement": achievementID,
				},
			}}}})

		return err
	} else {
		return err
	}
}
