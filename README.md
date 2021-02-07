# ecothon

![Deploy to kubernetes](https://github.com/JoeRourke123/ecothon/workflows/Deploy%20to%20kubernetes/badge.svg) 

Helping communities fight for the environment. Compete with friends and people in your area to be the most eco concious.

## Setup/usage

1. The frontend app can be built and tested using Android Studio with the Flutter and Dart SDKs installed
1. Backend can be run using `go run main.go` in the `/backend/` directory. If deploying this application yourself you will need to provide a MongoDB database, with the password in an environment variable -- you'll also need to supply secrets for an S3 compatible block storage provider to handle user image uploads.

## Technologies

### Frontend

* Flutter

### Backend

* Go, using the go-fiber web framework
* MongoDB, hosted on Atlas
* Hosted using Digital Ocean
* Block storage using Digital Ocean spaces
* Domain name from Domain.com

#### CI/CD

* Github Actions to create a Docker image
* Automatically deployed to a Kubernetes Cluster

## Screenshots

![Screenshots of the app](https://raw.githubusercontent.com/JoeRourke123/ecothon/main/backend/static/screenshot-combo.png)
