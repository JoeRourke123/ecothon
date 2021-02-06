package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/responses"
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
	collection, err := utils.GetMongoDbCollection("users")
	if err != nil {
		return fiber.ErrInternalServerError
	}

	var user models.User
	json.Unmarshal([]byte(c.Body()), &user)

	user.AccountCreated = time.Now()

	if user.LikedPosts == nil {
		user.LikedPosts = []primitive.ObjectID{}
	}
	if user.LikedPosts == nil {
		user.LikedPosts = []primitive.ObjectID{}
	}

	user.Password = generateHash([]byte(user.Password))

	res, err := collection.InsertOne(context.Background(), user)
	if err != nil {
		return fiber.ErrInternalServerError
	}

	return c.JSON(res)
}

func LoginUser(ctx *fiber.Ctx) error {
	type Login struct {
		Email    string `json:"email,omitempty"`
		Password string `json:"password,omitempty"`
	}

	var loginData Login
	json.Unmarshal([]byte(ctx.Body()), &loginData)

	collection, err := utils.GetMongoDbCollection("users")
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
				Email: user.Email,
				Username: user.Username,
				FirstName: user.FirstName,
				LastName: user.LastName,
				AccountCreated: user.AccountCreated,
				StartingCarbon: user.StartingCarbon,
				CurrentCarbon: user.CurrentCarbon,
			},
			Auth: &t,
		},
	)
}
