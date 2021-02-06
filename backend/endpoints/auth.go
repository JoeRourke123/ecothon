package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"time"

<<<<<<< HEAD
	"github.com/gofiber/fiber/v2"
)

func CreateUser(c *fiber.Ctx) error {
=======
	"github.com/gofiber/fiber"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"golang.org/x/crypto/bcrypt"
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

func CreateUser(c *fiber.Ctx) {
>>>>>>> c56fd2541399fd8ff88273956a4e78735e581409
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
