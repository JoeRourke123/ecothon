package endpoints

import (
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gofiber/fiber/v2"
)

type upload struct {
	Extension string `json:"extension,omitempty"`
}

func CreateUploadURL(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	var up upload
	json.Unmarshal([]byte(c.Body()), &up)

	key := os.Getenv("ECOTHON_SPACES_KEY")
	secret := os.Getenv("ECOTHON_SPACES_SECRET")

	s3Config := &aws.Config{
		Credentials: credentials.NewStaticCredentials(key, secret, ""),
		Endpoint:    aws.String("https://fra1.digitaloceanspaces.com"),
		Region:      aws.String("us-east-1"),
	}

	newSession := session.New(s3Config)
	s3Client := s3.New(newSession)

	req, _ := s3Client.PutObjectRequest(&s3.PutObjectInput{
		Bucket: aws.String("ecothon"),
		Key:    aws.String(fmt.Sprintf("%s-%s.%s", user.Username, strconv.FormatInt(time.Now().Unix(), 10), up.Extension)),
	})

	url, err := req.Presign(5 * time.Minute)
	if err != nil {
		fmt.Println(err.Error())
	}

	return c.JSON(map[string]string{"presigned_url": url})
}
