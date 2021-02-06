package endpoints

import (
	"context"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"

	"github.com/gofiber/fiber"
)

// func getPerson(c *fiber.Ctx) {
// 	collection, err := getMongoDbCollection(dbName, collectionName)
// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}

// 	var filter bson.M = bson.M{}

// 	if c.Params("id") != "" {
// 		id := c.Params("id")
// 		objID, _ := primitive.ObjectIDFromHex(id)
// 		filter = bson.M{"_id": objID}
// 	}

// 	var results []bson.M
// 	cur, err := collection.Find(context.Background(), filter)
// 	defer cur.Close(context.Background())

// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}

// 	cur.All(context.Background(), &results)

// 	if results == nil {
// 		c.SendStatus(404)
// 		return
// 	}

// 	json, _ := json.Marshal(results)
// 	c.Send(json)
// }

func CreateUser(c *fiber.Ctx) {
	collection, err := utils.GetMongoDbCollection("users")
	if err != nil {
		c.Status(500).Send(err)
		return
	}

	var user models.User
	json.Unmarshal([]byte(c.Body()), &user)

	res, err := collection.InsertOne(context.Background(), user)
	if err != nil {
		c.Status(500).Send(err)
		return
	}

	response, _ := json.Marshal(res)
	c.Send(response)
}

// func updatePerson(c *fiber.Ctx) {
// 	collection, err := getMongoDbCollection(dbName, collectionName)
// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}
// 	var person Person
// 	json.Unmarshal([]byte(c.Body()), &person)

// 	update := bson.M{
// 		"$set": person,
// 	}

// 	objID, _ := primitive.ObjectIDFromHex(c.Params("id"))
// 	res, err := collection.UpdateOne(context.Background(), bson.M{"_id": objID}, update)

// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}

// 	response, _ := json.Marshal(res)
// 	c.Send(response)
// }

// func deletePerson(c *fiber.Ctx) {
// 	collection, err := getMongoDbCollection(dbName, collectionName)

// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}

// 	objID, _ := primitive.ObjectIDFromHex(c.Params("id"))
// 	res, err := collection.DeleteOne(context.Background(), bson.M{"_id": objID})

// 	if err != nil {
// 		c.Status(500).Send(err)
// 		return
// 	}

// 	jsonResponse, _ := json.Marshal(res)
// 	c.Send(jsonResponse)
// }
