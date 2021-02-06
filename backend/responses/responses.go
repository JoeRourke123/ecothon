package responses

import (
	"time"
)

// UserResponse todo
type UserResponse struct {
	FirstName      string               `json:"first_name,omitempty"`
	LastName       string               `json:"last_name,omitempty"`
	Username       string               `json:"username,omitempty"`
	Email          string               `json:"email,omitempty"`
	StartingCarbon float32              `json:"carbon_estimate,omitempty"`
	CurrentCarbon  float32              `json:"current_estimate,omitempty"`
	AccountCreated time.Time            `json:"account_created,omitempty"`
}

// AccessResponse todo
type AccessResponse struct {
	Token string `json:"token"`
}

// AuthResponse todo
type AuthResponse struct {
	User *UserResponse   `json:"user"`
	Auth *string `json:"auth"`
}
