package internal

import (
	"errors"
	"log"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

type Auth struct {
	Secret string
}

func SetupAuth(secret string) Auth {
	return Auth{
		Secret: secret,
	}
}

func (a Auth) VerifyToken(token string) (string, error) {
	tokenArr := strings.Split(token, " ")
	if len(tokenArr) != 2 {
		return "", errors.New("Invalid token")
	}

	if tokenArr[0] != "Bearer" {
		return "", errors.New("Invalid token")
	}

	parsedToken, err := jwt.Parse(
		tokenArr[1],
		func(token *jwt.Token) (any, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				log.Printf("Invalid token signing method")
				return "", errors.New("Invalid token")
			}
			return []byte(a.Secret), nil
		},
	)

	if err != nil {
		return "", errors.New("Invalid token")
	}

	claims, ok := parsedToken.Claims.(jwt.MapClaims)
	if !ok {
		return "", errors.New("Invalid token")
	}

	userId := claims["_id"].(string)
	return userId, nil
}
