package algo_test

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"hungknow.com/algo"
)

func rateLimitterHttpCall(client http.Client, url string) (*http.Response, error) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}
	res, err := client.Do(req)
	if err != nil {
		return nil, err
	}

	return res, nil
}

func callForSeconds(client http.Client, url string, seconds time.Duration) error {
	timer := time.NewTimer(seconds)

	for {
		select {
		case <-timer.C:
			return nil
		default:
			_, err := rateLimitterHttpCall(client, url)
			if err != nil {
				return err
			}
		}
	}
}

type rateCounter struct {
	FromTime time.Time
	ToTime   time.Time
	Count    int
}

func NewRateCounter() *rateCounter {
	return &rateCounter{
		Count: 0,
	}
}

func (c *rateCounter) SetSeconds(seconds time.Duration) {
	now := time.Now()
	c.FromTime = now
	c.ToTime = now.Add(seconds)
	c.Count = 0
}

func (c *rateCounter) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	if c.ToTime.After(time.Now()) {
		c.Count++
	}
}

func TestRateLimiter(t *testing.T) {
	var err error
	counter := NewRateCounter()
	// Set up the mock HTTP server
	server := httptest.NewServer(counter)
	// server.Start()
	defer server.Close()

	t.Run("RateLimitter1Transport", func(t *testing.T) {
		expectedCount := 3
		client := http.Client{
			Transport: algo.NewRateLimitter1Transport(time.Second, expectedCount, http.DefaultTransport),
		}
		counter.SetSeconds(time.Second)
		err = callForSeconds(client, server.URL, time.Second * 2)
		require.NoError(t, err)
		require.Equal(t, expectedCount, counter.Count)
	})
}
