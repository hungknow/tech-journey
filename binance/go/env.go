package gobinance

import (
	"os"
	"runtime"

	"path/filepath"

	"github.com/joho/godotenv"
)

type EnvContent struct {
	BinanceAPIKey    string
	BinanceSecretKey string
	BinanceAPIPath   string
}

func ReadEnv() *EnvContent {
	_, b, _, _ := runtime.Caller(0)
	basepath := filepath.Dir(b)
	err := godotenv.Load(basepath + "/.env")
	if err != nil {
		panic(err)
	}

	binanceApiKey := os.Getenv("BINANCE_API_KEY")
	binanceSecretKey := os.Getenv("BINANCE_SECRET_KEY")
	binanceAPIPath := os.Getenv("BINANCE_API_PATH")

	return &EnvContent{
		BinanceAPIKey:    binanceApiKey,
		BinanceSecretKey: binanceSecretKey,
		BinanceAPIPath:   binanceAPIPath,
	}
}
