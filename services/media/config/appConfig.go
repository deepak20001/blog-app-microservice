package config

import (
	"os"

	"github.com/joho/godotenv"
)

type AppConfig struct {
	ServerPort     string
	CloudName      string
	CloudApiKey    string
	CloudApiSecret string
	JwtSecret      string
}

func SetUpEnv() (cfg *AppConfig, err error) {
	err = godotenv.Load()
	if err != nil {
		return nil, err
	}
	cfg = &AppConfig{
		ServerPort:     os.Getenv("PORT"),
		CloudName:      os.Getenv("CLOUD_NAME"),
		CloudApiKey:    os.Getenv("CLOUD_API_KEY"),
		CloudApiSecret: os.Getenv("CLOUD_API_SECRET"),
		JwtSecret:      os.Getenv("JWT_SECRET"),
	}

	return cfg, nil
}
