package algo

import (
	"net/http"
	"time"

	"golang.org/x/time/rate"
)

type RateLimitter1Transport struct {
	roundTripperWrap http.RoundTripper
	ratelimitter     *rate.Limiter
}

func (c *RateLimitter1Transport) RoundTrip(r *http.Request) (*http.Response, error) {
	err := c.ratelimitter.Wait(r.Context())
	if err != nil {
		return nil, err
	}
	return c.roundTripperWrap.RoundTrip(r)
}

func NewRateLimitter1Transport(limitPeriod time.Duration, requestCount int, roundTripper http.RoundTripper) *RateLimitter1Transport {
	return &RateLimitter1Transport{
		roundTripperWrap: roundTripper,
		ratelimitter:     rate.NewLimiter(rate.Every(limitPeriod), requestCount),
	}
}
