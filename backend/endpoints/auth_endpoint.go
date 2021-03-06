package endpoints

import (
	"ecothon/models"
	"ecothon/responses"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"go.mongodb.org/mongo-driver/bson"
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

	user.AccountCreated = time.Now()
	user.Points = 0

	user.Achievements = []bson.M{}
	user.Followers = []string{}
	user.Following = []string{}

	user.CurrentCarbon = user.StartingCarbon

	user.Password = generateHash([]byte(user.Password))

	_, err = collection.InsertOne(c.Context(), user)
	if err != nil {
		return fiber.ErrInternalServerError
	}


	t := utils.Generate(&utils.TokenPayload{
		Username: user.Username,
	})

	return c.JSON(
		&responses.AuthResponse{
			User: &responses.UserResponse{
				Email:          user.Email,
				Username:       user.Username,
				FirstName:      user.FirstName,
				LastName:       user.LastName,
				AccountCreated: user.AccountCreated,
				StartingCarbon: user.StartingCarbon,
				CurrentCarbon:  user.CurrentCarbon,
			},
			Auth: &t,
		},
	)
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
		Username: user.Username,
	})

	return ctx.JSON(
		&responses.AuthResponse{
			User: &responses.UserResponse{
				Email:          user.Email,
				Username:       user.Username,
				FirstName:      user.FirstName,
				LastName:       user.LastName,
				AccountCreated: user.AccountCreated,
				StartingCarbon: user.StartingCarbon,
				CurrentCarbon:  user.CurrentCarbon,
			},
			Auth: &t,
		},
	)
}

func UserProfile(c *fiber.Ctx) error {
	var currentUser models.User
	currentUsername := c.Locals("USER").(string)
	utils.GetUser(currentUsername, c, &currentUser)

	var user models.User
	viewingUsername := c.Params("username")
	utils.GetUser(viewingUsername, c, &user)

	var isFollowing bool
	if len(user.Followers) < len(currentUser.Following) {
		isFollowing = utils.BinarySearch(user.Followers, currentUsername)
	} else {
		isFollowing = utils.BinarySearch(currentUser.Following, c.Params("username"))
	}

	var posts []models.ReturnPost
	utils.GetPosts(viewingUsername, &posts, c)

	if user.Followers == nil {
		user.Followers = make([]string, 0)
	}
	if user.Following == nil {
		user.Following = make([]string, 0)
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
	currentUsername := c.Locals("USER").(string)
	utils.GetUser(currentUsername, c, &currentUser)

	var user models.User
	viewingUsername := c.Params("username")
	utils.GetUser(viewingUsername, c, &user)

	collection, _ := utils.GetMongoDbCollection(c, "users")
	collection.UpdateOne(c.Context(), bson.M{
		"username": currentUsername,
	}, bson.M{
		"$push": bson.M{
			"following": bson.M{
				"$each": bson.A{ viewingUsername },
				"$sort": 1,
			},
		},
	})
	collection.UpdateOne(c.Context(), bson.M{
		"username": viewingUsername,
	}, bson.M{
		"$push": bson.M{
			"followers": bson.M{
				"$each": bson.A{ currentUsername },
				"$sort": 1,
			},
		},
	})

	return c.SendStatus(fiber.StatusOK)
}

func SetProfilePicture(c *fiber.Ctx) error {
	var user models.User
	username := c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	collection, err := utils.GetMongoDbCollection(c, "users")

	var parsed models.User
	json.Unmarshal(c.Body(), &parsed)

	if err != nil {
		return fiber.ErrInternalServerError
	}

	_, err = collection.UpdateOne(c.Context(), bson.M{
		"username": username,
	}, bson.M{
		"$set": bson.M{
			"profilepicture": parsed.ProfilePicture,
		},
	})

	return c.SendStatus(fiber.StatusOK)
}
