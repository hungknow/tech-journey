package market

import (
	"context"
	"testing"

	binance_connector "github.com/binance/binance-connector-go"
	gobinance "hungknow.com/go-binance"
)

func TestKlines(t *testing.T) {
	envContent := gobinance.ReadEnv()
	ctx := context.Background()
	client := binance_connector.NewClient(envContent.BinanceAPIKey, envContent.BinanceSecretKey, envContent.BinanceAPIPath)
	klineService := client.NewKlinesService()
	klines, err := klineService.Symbol("BTCUSDT").Interval("1m").Limit(10).Do(ctx)
	if err != nil {
		panic(err)
	}
	t.Log(binance_connector.PrettyPrint(klines))
}
