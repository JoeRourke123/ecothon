package endpoints

import (
	"context"
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
	error := bcrypt.CompareHashAndPassword(hashedPassword, checkPassword)

	if error == nil {
		return true
	}

	return false
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

	//collection, err := utils.GetMongoDbCollection("users")
	//if err != nil {
	//	return fiber.ErrInternalServerError
	//}

	var user models.User
	//
	//filter := bson.D{
	//	{
	//		"$and",
	//		bson.A{
	//			bson.D{{ "email", loginData.Email}},
	//		},
	//	},
	//}

	//cur := collection.FindOne(ctx.Context(), &filter)

	t := utils.Generate(&utils.TokenPayload{
		Username: user.Username,
	})

	return ctx.JSON(bson.D{
		{"user", ctx.JSON(user)},
		{"tokens", ctx.JSON(t)},
	})
}
