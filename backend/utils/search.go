package utils

import (
	"ecothon/models"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func BinarySearch(a []primitive.ObjectID, search primitive.ObjectID) bool {
	mid := len(a) / 2
	switch {
	case len(a) == 0:
		return false // not found
	case a[mid].String() > search.String():
		return BinarySearch(a[:mid], search)
	case a[mid].String() < search.String():
		return BinarySearch(a[mid+1:], search)
	default: // a[mid] == search
		return true // found
	}
}

func SearchUserAchievements(a []models.UserAchievement, achievement primitive.ObjectID) bool {
	mid := len(a) / 2
	switch {
	case len(a) == 0:
		return false // not found
	case a[mid].Achievement.String() > achievement.String():
		return SearchUserAchievements(a[:mid], achievement)
	case a[mid].Achievement.String() < achievement.String():
		return SearchUserAchievements(a[mid+1:], achievement)
	default: // a[mid] == search
		return true // found
	}
}
