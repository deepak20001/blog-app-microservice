package internal

import (
	"context"
	"log"
	"path/filepath"
	"strings"
	"time"

	"github.com/cloudinary/cloudinary-go/v2"
	"github.com/cloudinary/cloudinary-go/v2/api/uploader"
	"github.com/deepak20001/media/config"
	"github.com/gofiber/fiber/v3"
)

func SetupRoutes(cfg *config.AppConfig, app *fiber.App, cld *cloudinary.Cloudinary, auth Auth) {
	var fileSize int64 = 5 * 1024 * 1024

	app.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"success": true,
			"message": "Health check done successfully.",
		})
	})

	app.Post("/api/v1/media/avatar-upload", func(c fiber.Ctx) error {
		authHeader := c.Get("Authorization")
		userID, err := auth.VerifyToken(authHeader)
		if err != nil || userID == "" {
			return c.Status(fiber.StatusUnauthorized).
				JSON(fiber.Map{
					"success": false,
					"message": "Invalid token",
				})
		}

		file, err := c.FormFile("file")
		if err != nil {
			log.Println("file received:", err)
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "No file received",
				})
		}

		if file.Size > fileSize {
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "File size is too large, max size is 5MB",
				})
		}

		allowedExts := map[string]bool{
			".jpg":  true,
			".jpeg": true,
			".png":  true,
			"/webp": true,
		}

		ext := strings.ToLower(filepath.Ext(file.Filename))
		if !allowedExts[ext] {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"success": false,
				"error":   "Only JPG, JPEG, PNG and WebP files are allowed",
			})
		}

		src, err := file.Open()
		if err != nil {
			log.Println("Opening file:", err)
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "cannot open received file",
				})
		}

		defer src.Close()
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()
		res, err := cld.Upload.Upload(ctx, src, uploader.UploadParams{
			Folder: "blog-app-storage/avatars",
		})
		if err != nil {
			log.Println("cloudinary upload:", err)
			return c.Status(fiber.StatusInternalServerError).
				JSON(fiber.Map{"error": "upload to Cloudinary failed"})
		}

		return c.JSON(fiber.Map{
			"success":  true,
			"fileName": file.Filename,
			"fileSize": file.Size,
			"url":      res.SecureURL,
		})

	})

	app.Post("/api/v1/media/blog-image", func(c fiber.Ctx) error {
		authHeader := c.Get("Authorization")
		userID, err := auth.VerifyToken(authHeader)
		if err != nil || userID == "" {
			return c.Status(fiber.StatusUnauthorized).
				JSON(fiber.Map{
					"success": false,
					"message": "Invalid token",
				})
		}

		file, err := c.FormFile("file")
		if err != nil {
			log.Println("file received:", err)
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "No file received",
				})
		}

		if file.Size > fileSize {
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "File size is too large, max size is 5MB",
				})
		}

		allowedExts := map[string]bool{
			".jpg":  true,
			".jpeg": true,
			".png":  true,
			"/webp": true,
		}

		ext := strings.ToLower(filepath.Ext(file.Filename))
		if !allowedExts[ext] {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"success": false,
				"error":   "Only JPG, JPEG, PNG and WebP files are allowed",
			})
		}

		src, err := file.Open()
		if err != nil {
			log.Println("Opening file:", err)
			return c.Status(fiber.StatusBadRequest).
				JSON(fiber.Map{
					"success": false,
					"message": "cannot open received file",
				})
		}

		defer src.Close()
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()
		res, err := cld.Upload.Upload(ctx, src, uploader.UploadParams{
			Folder: "blog-app-storage/blog-images",
		})
		if err != nil {
			log.Println("cloudinary upload:", err)
			return c.Status(fiber.StatusInternalServerError).
				JSON(fiber.Map{"error": "upload to Cloudinary failed"})
		}

		return c.JSON(fiber.Map{
			"success":  true,
			"fileName": file.Filename,
			"fileSize": file.Size,
			"url":      res.SecureURL,
		})
	})
}
