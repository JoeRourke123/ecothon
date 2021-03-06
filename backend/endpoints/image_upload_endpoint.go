package endpoints

import (
	"bytes"
	"ecothon/models"
	"ecothon/utils"
	"encoding/json"
	"fmt"
	"image"
	"image/jpeg"
	_ "image/png" //need to decode pngs
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gofiber/fiber/v2"
	"github.com/nfnt/resize"
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

	originalBytes := bytes.NewReader(c.Body())

	config, ext, err := image.DecodeConfig(originalBytes)
	if err != nil {
		fmt.Println(err.Error())
		return c.Status(422).JSON(map[string]string{"error": "This image is invalid - please send .jpg or .png"})
	}

	bytesOut := new(bytes.Buffer)

	originalBytes.Reset(c.Body())
	if config.Height > 800 || config.Width > 800 {
		defer func() {
			if err := recover(); err != nil {
				fmt.Println("Image could not be resized:", err)
				c.Status(422).JSON(map[string]string{"error": "This image could not be resized"})
			}
		}()

		srcImage, _, decodeErr := image.Decode(originalBytes)
		if decodeErr != nil {
			fmt.Println(decodeErr.Error())
			return c.Status(422).JSON(map[string]string{"error": "This image is corrupted"})
		}

		dstImage := resize.Resize(800, 0, srcImage, resize.Lanczos3)

		encodeErr := jpeg.Encode(bytesOut, dstImage, nil)
		if encodeErr != nil {
			fmt.Println(encodeErr.Error())
			return c.Status(422).JSON(map[string]string{"error": "Could not encode this image"})
		}

		ext = "jpg"
	} else {
		bytesOut.ReadFrom(originalBytes)
	}

	filename := fmt.Sprintf("%s-%s.%s", user.Username, strconv.FormatInt(time.Now().Unix(), 10), ext)

	key := os.Getenv("ECOTHON_SPACES_KEY")
	secret := os.Getenv("ECOTHON_SPACES_SECRET")

	s3Config := &aws.Config{
		Credentials: credentials.NewStaticCredentials(key, secret, ""),
		Endpoint:    aws.String("https://fra1.digitaloceanspaces.com"),
		Region:      aws.String("fra1"),
	}

	newSession := session.New(s3Config)
	s3Client := s3.New(newSession)

	object := s3.PutObjectInput{
		Bucket:      aws.String("ecothon"),
		Key:         aws.String(filename),
		Body:        bytes.NewReader(bytesOut.Bytes()),
		ACL:         aws.String("public-read"),
		ContentType: aws.String("image/" + ext),
	}

	_, uploadErr := s3Client.PutObject(&object)
	if uploadErr != nil {
		fmt.Println(uploadErr.Error())
		return c.Status(500).JSON(map[string]string{"error": "Failed to upload image to s3"})
	}

	return c.Status(201).JSON(map[string]string{"url": "https://ecothon.fra1.digitaloceanspaces.com/" + filename})
}
