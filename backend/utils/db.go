package utils

import (
	"fmt"
	"github.com/gofiber/fiber/v2"
	"log"
	"os"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

//GetMongoDbConnection get connection of mongodb
func GetMongoDbConnection(c *fiber.Ctx) (*mongo.Client, error) {

	client, err := mongo.Connect(c.Context(), options.Client().ApplyURI(fmt.Sprintf("mongodb+srv://ecothon:%s@ecothon.xkbqr.mongodb.net/ecothon?retryWrites=true&w=majority", os.Getenv("ECOTHON_DB_PASS"))))

	if err != nil {
		log.Fatal(err)
	}

	err = client.Ping(c.Context(), readpref.Primary())
	if err != nil {
		log.Fatal(err)
	}

	return client, nil
}

func GetMongoDbCollection(c *fiber.Ctx, CollectionName string) (*mongo.Collection, error) {
	client, err := GetMongoDbConnection(c)

	if err != nil {
		return nil, err
	}

	collection := client.Database("ecothon").Collection(CollectionName)

	return collection, nil
}
