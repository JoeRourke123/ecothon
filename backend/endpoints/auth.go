package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"time"

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
	collection, err := utils.GetMongoDbCollection("users")
	if err != nil {
		c.Status(500).Send(err)
		return
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
		c.Status(500).Send(err)
		return
	}

	response, _ := json.Marshal(res)
	c.Send(response)
}
