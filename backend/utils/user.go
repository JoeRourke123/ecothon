package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

func GetUser(username string, c *fiber.Ctx, user *models.User) {
	collection, err := GetMongoDbCollection(c,"users")

	if username == "" || err != nil {
		return
	}

	filter := bson.M{"username": username}

	cur := collection.FindOne(c.Context(), filter)

	cur.Decode(user)
}

func AddUserAchievement(username string, postID primitive.ObjectID,
	achievementID primitive.ObjectID, c *fiber.Ctx, now time.Time) error {
	achievementCol, err := GetMongoDbCollection(c,"achievements")

	if err != nil {
		return err
	}

	var achievement bson.M
	cur := achievementCol.FindOne(c.Context(), bson.D{{"_id", achievementID}})
	cur.Decode(&achievement)


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
		userCol, _ := GetMongoDbCollection(c,"users")

		_, err = userCol.UpdateOne(c.Context(),
			bson.D{{"username", username}},
			bson.M{"$push": bson.D{{
				"achievements", bson.M{
					"achievedAt":  now,
					"post":        postID,
					"achievement": achievementID,
				},
			}},
			"$inc": bson.D{{
				"points", achievement["points"],
				}},
			})

		return err
	} else {
		return err
	}
}

func GetPosts(username string, posts *[]models.ReturnPost, c *fiber.Ctx) {
	postCol, _ := GetMongoDbCollection(c,"posts")

	cur, _ := postCol.Find(c.Context(), bson.D{{
		"user", username,
	}})


	achievementsCollection, _ := GetMongoDbCollection(c, "achievements")

	*posts = make([]models.ReturnPost, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var r models.ReturnPost
		cur.Decode(&r)

		r.ID = cur.Current.Index(0).Value().ObjectID()
		r.IsLiked = BinarySearch(r.LikedBy, username)

		aCur := achievementsCollection.FindOne(c.Context(), bson.D{
			{"_id", r.Achievement},
		})
		aCur.Decode(&r.AchievementObj)

		(*posts)[i] = r
		i++
	}

	defer cur.Close(c.Context())
}
