package utils

import (
	"context"
"log"
"os"
"fmt"

"go.mongodb.org/mongo-driver/mongo"
"go.mongodb.org/mongo-driver/mongo/options"
"go.mongodb.org/mongo-driver/mongo/readpref"
)

//GetMongoDbConnection get connection of mongodb
func GetMongoDbConnection() (*mongo.Client, error) {

	client, err := mongo.Connect(context.Background(), options.Client().ApplyURI(fmt.Sprintf("mongodb+srv://ecothon:%s@ecothon.xkbqr.mongodb.net/ecothon?retryWrites=true&w=majority", os.Getenv("ECOTHON_DB_PASS"))))

	if err != nil {
		log.Fatal(err)
	}

	err = client.Ping(context.Background(), readpref.Primary())
	if err != nil {
		log.Fatal(err)
	}

	return client, nil
}

func getMongoDbCollection(DbName string, CollectionName string) (*mongo.Collection, error) {
	client, err := GetMongoDbConnection()

	if err != nil {
		return nil, err
	}

	collection := client.Database(DbName).Collection(CollectionName)

	return collection, nil
}
