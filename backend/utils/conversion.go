package utils

import "ecothon/models"

func GetSerialisedAchievement(a *models.Achievement, user *models.User) models.SerialisedAchievement {
	var s models.SerialisedAchievement

	completed := SearchUserAchievements(user.Achievements, a.ID)

	s.ID = a.ID
	s.Title = a.Title
	s.Points = a.Points
	s.CarbonReduction = a.CarbonReduction
	s.Image = a.Image
	s.Repeating = a.Repeating
	s.Completed = completed
	s.AchievedCount = int16(len(a.AchievedBy))

	return s
}

func GetSerialisedPost(p *models.Post, a *models.SerialisedAchievement, u *models.SerialisedUser, user *models.User) models.SerialisedPost {
	var s models.SerialisedPost

	isLiked := user != nil && BinarySearch(p.LikedBy, user.ID)

	s.ID = p.ID
	s.User = *u
	s.Achievement = *a
	s.Type = p.Type
	s.CreatedAt = p.CreatedAt
	s.IsLiked = isLiked
	s.LikeCount = int16(len(p.LikedBy))
	s.Details = p.Details
	s.Geolocation = p.Geolocation
	s.Picture = p.Picture

	return s
}

func GetSerialisedUser(u *models.User, me *models.User) models.SerialisedUser {
	var s models.SerialisedUser

	isFollowing := false
	if me != nil {
		if len(me.Following) < len(u.Followers) {
			isFollowing = BinarySearch(me.Following, u.ID)
		} else {
			isFollowing = BinarySearch(u.Followers, me.ID)
		}
	}

	s.Username = u.Username
	s.Points = u.Points
	s.ProfilePicture = u.ProfilePicture
	s.ID = u.ID
	s.IsFollowing = isFollowing
	s.IsSecret = u.IsSecret
	s.FirstName = u.FirstName
	s.LastName = u.LastName
	s.CurrentCarbon = u.CurrentCarbon
	s.StartingCarbon = u.StartingCarbon

	return s
}
