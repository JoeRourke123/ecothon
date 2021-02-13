package utils

import (
	"ecothon/models"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	options2 "go.mongodb.org/mongo-driver/mongo/options"
)

func AddUserAchievement(user models.User, c *fiber.Ctx, ach *models.Achievement, uAch models.UserAchievement) error {
	userCol, _ := GetMongoDbCollection(c, "users")

	_, err := userCol.UpdateOne(c.Context(),
		bson.D{{"_id", user.ID}},
		bson.M{"$push": bson.M{
			"achievements": bson.M{
				"$each": bson.A{uAch},
			},
		},
		"$inc": bson.M{
			"points": ach.Points,
		},
})

return err
}

func GetPosts(userID primitive.ObjectID, posts *[]models.SerialisedPost, c *fiber.Ctx, user *models.User) {
	postCol, _ := GetMongoDbCollection(c, "posts")

	options := options2.Find()
	options.SetSort(bson.M{
		"created_at": -1,
	})

	cur, _ := postCol.Find(c.Context(), bson.D{{
		"user", userID,
	}}, options)

	*posts = make([]models.SerialisedPost, cur.RemainingBatchLength())
	i := 0
	for cur.Next(c.Context()) {
		var r models.Post
		cur.Decode(&r)

		var a models.Achievement
		GetAchievement(r.Achievement, c, &a)

		var u models.User
		GetUser(r.User, c, &u)

		su := GetSerialisedUser(&u, user)
		sa := GetSerialisedAchievement(&a, user)

		(*posts)[i] = GetSerialisedPost(&r, &sa, &su, user)
		i++
	}

	defer cur.Close(c.Context())
}
