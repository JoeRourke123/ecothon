package utils

import (
	"context"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

//GetMongoDbConnection get connection of mongodb
func GetMongoDbConnection(c *fiber.Ctx) (*mongo.Client, error) {

	client, err := mongo.NewClient(options.Client().ApplyURI(fmt.Sprintf("mongodb+srv://ecothon:%s@ecothon.xkbqr.mongodb.net/ecothon?retryWrites=true&w=majority", os.Getenv("ECOTHON_DB_PASS"))))

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err != nil {
		return nil, err
	}

	err = client.Connect(ctx)

	if err != nil {
		return nil, err
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
