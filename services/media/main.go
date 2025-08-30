package main

import (
	"log"

	"github.com/cloudinary/cloudinary-go/v2"
	"github.com/deepak20001/media/config"
	"github.com/deepak20001/media/internal"
	"github.com/gofiber/fiber/v3"
)

func main() {
	cfg, err := config.SetUpEnv()
	if err != nil {
		log.Fatalf("Error loading environment variables: %v\n", err)
	}

	cld, err := cloudinary.NewFromParams(cfg.CloudName, cfg.CloudApiKey, cfg.CloudApiSecret)
	if err != nil {
		log.Fatalf("Error connecting cloudinary: %v\n", err)
	}

	app := fiber.New(fiber.Config{
		AppName: "Media Service",
	})

	auth := internal.SetupAuth(cfg.JwtSecret)
	internal.SetupRoutes(cfg, app, cld, auth)
	app.Listen(":" + cfg.ServerPort)
}
