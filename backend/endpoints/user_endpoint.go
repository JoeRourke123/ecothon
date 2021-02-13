package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
	"time"
)

func checkPass(checkPassword, hashedPassword []byte) bool {
	return bcrypt.CompareHashAndPassword(hashedPassword, checkPassword) == nil
}

func generateHash(pass []byte) string {
	hash, err := bcrypt.GenerateFromPassword(pass, bcrypt.MinCost)

	if err != nil {
		fmt.Println("Error generating hash")
	}

	return string(hash)
}

func CreateUser(c *fiber.Ctx) error {
	collection, err := utils.GetMongoDbCollection(c,"users")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var user models.User
	json.Unmarshal([]byte(c.Body()), &user)

	cur, err := collection.Find(c.Context(), bson.D{{ "username", user.Username}})
	if cur.RemainingBatchLength() > 0 {
		return c.JSON(bson.M{ "error": "An account with that username already exists! "})
	}

	cur, err = collection.Find(c.Context(), bson.D{{ "email", user.Email}})
	if cur.RemainingBatchLength() > 0 {
		return c.JSON(bson.M{ "error": "An account with that email already exists! "})
	}

	user.ID = primitive.NewObjectID()
	user.AccountCreated = time.Now()
	user.Points = 0

	user.Achievements = []models.UserAchievement{}
	user.Followers = []primitive.ObjectID{}
	user.Following = []primitive.ObjectID{}

	user.CurrentCarbon = user.StartingCarbon

	user.Password = generateHash([]byte(user.Password))

	_, err = collection.InsertOne(c.Context(), user)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	t := utils.Generate(&utils.TokenPayload{
		ID: user.ID.Hex(),
	})

	serialisedUser := utils.GetSerialisedUser(&user, nil)

	return c.JSON(
		bson.M{
			"user": serialisedUser,
			"auth": t,
		},
	)
}

func GetUserDetails(c *fiber.Ctx) error {
	id, _ := primitive.ObjectIDFromHex(c.Params("id"))

	var user models.User
	utils.GetUser(id, c, &user)

	serialised := utils.GetSerialisedUser(&user, nil)

	return c.JSON(serialised)
}

func LoginUser(ctx *fiber.Ctx) error {
	type Login struct {
		Email    string `json:"email,omitempty"`
		Password string `json:"password,omitempty"`
	}

	var loginData Login


	json.Unmarshal([]byte(ctx.Body()), &loginData)

	print(loginData.Email)
	print(loginData.Password)

	collection, err := utils.GetMongoDbCollection(ctx, "users")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var user models.User

	filter := bson.D{
		{
			"email", loginData.Email,
		},
	}

	cur := collection.FindOne(ctx.Context(), &filter)

	if cur.Err() != nil {
		return ctx.Status(403).JSON(map[string]string{"error": "We can't find an account with that email!"})
	}

	cur.Decode(&user)

	if !checkPass([]byte(loginData.Password), []byte(user.Password)) {
		return ctx.Status(403).JSON(map[string]string{"error": "That's not your password!"})
	}

	t := utils.Generate(&utils.TokenPayload{
		ID: user.ID.Hex(),
	})

	serialisedUser := utils.GetSerialisedUser(&user, nil)

	return ctx.JSON(
		bson.M{
			"user": serialisedUser,
			"auth": t,
		},
	)
}

func UserProfile(c *fiber.Ctx) error {
	var currentUser models.User
	currentUID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(currentUID, c, &currentUser)

	var user models.User
	viewingUID, _ := primitive.ObjectIDFromHex(c.Params("user_id"))
	utils.GetUser(viewingUID, c, &user)

	var isFollowing bool
	if len(user.Followers) < len(currentUser.Following) {
		isFollowing = utils.BinarySearch(user.Followers, currentUID)
	} else {
		isFollowing = utils.BinarySearch(currentUser.Following, viewingUID)
	}

	var posts []models.SerialisedPost
	utils.GetPosts(viewingUID, &posts, c, &currentUser)

	if user.Followers == nil {
		user.Followers = make([]primitive.ObjectID, 0)
	}
	if user.Following == nil {
		user.Following = make([]primitive.ObjectID, 0)
	}

	print(user.Username)

	return c.JSON(bson.M{
		"following": isFollowing,
		"user":      user,
		"posts":     posts,
	})
}

func UserFollow(c *fiber.Ctx) error {
	var currentUser models.User
	currentUID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(currentUID, c, &currentUser)

	var user models.User
	viewingUID, _ := primitive.ObjectIDFromHex(c.Params("user_id"))
	utils.GetUser(viewingUID, c, &user)

	collection, _ := utils.GetMongoDbCollection(c, "users")
	collection.UpdateOne(c.Context(), bson.M{
		"_id": currentUID,
	}, bson.M{
		"$push": bson.M{
			"following": bson.M{
				"$each": bson.A{ viewingUID },
				"$sort": 1,
			},
		},
	})
	collection.UpdateOne(c.Context(), bson.M{
		"_id": viewingUID,
	}, bson.M{
		"$push": bson.M{
			"followers": bson.M{
				"$each": bson.A{ currentUID },
				"$sort": 1,
			},
		},
	})

	return c.SendStatus(fiber.StatusOK)
}

func SetProfilePicture(c *fiber.Ctx) error {
	var user models.User
	userID, _ := primitive.ObjectIDFromHex(c.Locals("USER").(string))
	utils.GetUser(userID, c, &user)


	collection, err := utils.GetMongoDbCollection(c, "users")

	var parsed models.User
	json.Unmarshal(c.Body(), &parsed)

	if err != nil {
		return fiber.ErrInternalServerError
	}

	_, err = collection.UpdateOne(c.Context(), bson.M{
		"_id": userID,
	}, bson.M{
		"$set": bson.M{
			"profile_picture": parsed.ProfilePicture,
		},
	})

	return c.SendStatus(fiber.StatusOK)
}
