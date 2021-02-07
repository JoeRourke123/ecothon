package endpoints

import (
	"bytes"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
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

// CreateUploadURL generates a presigned URL to allow uploading to the
// Digital Ocean Spaces bucket
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
		Region:      aws.String("fra1"),
	}

	newSession := session.New(s3Config)
	s3Client := s3.New(newSession)

	filename := fmt.Sprintf("%s-%s.%s", user.Username, strconv.FormatInt(time.Now().Unix(), 10), up.Extension)

	content := fmt.Sprintf("image/%s", up.Extension)

	acl := "public-read"
	req, _ := s3Client.PutObjectRequest(&s3.PutObjectInput{
		Bucket:      aws.String("ecothon"),
		Key:         aws.String(filename),
		ContentType: aws.String(content),
		ACL:         &acl,
		//ContentMD5:  aws.String("false"),
	})

	url, err := req.Presign(5 * time.Minute) //change this
	if err != nil {
		fmt.Println(err.Error())
	}

	var buf bytes.Buffer
	enc := json.NewEncoder(&buf)
	enc.SetEscapeHTML(false)

	enc.Encode(map[string]string{"presigned_url": url, "final_url": strings.Split(url, "?")[0], "filename": filename})

	return c.Send([]byte(buf.Bytes()))
}

// UploadImage uploads an image to S3 directly, i.e. not doing it client side
func UploadImage(c *fiber.Ctx) error {
	var user models.User
	var username string = c.Locals("USER").(string)
	utils.GetUser(username, c, &user)

	fmt.Println(string(c.Request().Header.ContentType()))

	key := os.Getenv("ECOTHON_SPACES_KEY")
	secret := os.Getenv("ECOTHON_SPACES_SECRET")

	s3Config := &aws.Config{
		Credentials: credentials.NewStaticCredentials(key, secret, ""),
		Endpoint:    aws.String("https://fra1.digitaloceanspaces.com"),
		Region:      aws.String("fra1"),
	}

	newSession := session.New(s3Config)
	s3Client := s3.New(newSession)

	ext := strings.Split(string(c.Request().Header.ContentType()), "/")[1]

	filename := fmt.Sprintf("%s-%s.%s", user.Username, strconv.FormatInt(time.Now().Unix(), 10), ext)

	object := s3.PutObjectInput{
		Bucket:      aws.String("ecothon"),
		Key:         aws.String(filename),
		Body:        bytes.NewReader(c.Body()),
		ACL:         aws.String("public-read"),
		ContentType: aws.String(string(c.Request().Header.ContentType())),
	}

	_, err := s3Client.PutObject(&object)
	if err != nil {
		fmt.Println(err.Error())
	}

	return c.JSON(map[string]string{"url": "https://ecothon.fra1.digitaloceanspaces.com/" + filename})
}
