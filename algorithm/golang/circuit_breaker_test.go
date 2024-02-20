package algo_test

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"hungknow.com/algo"
)

func TestNewBreakerAllows(t *testing.T) {
	c := algo.NewcirCuitBreaker1(0)

	require.True(t, c.Allow(), "expected new breaker to be closed")

	algo.ExportCircuitBreaker1Trip(c)

	require.False(t, c.Allow(), "expected new breaker to be open")

	c.Success(0)
	require.True(t, c.Allow(), "expected breaker to be closed after success")
}

func TestNewBreaker1(t *testing.T) {
	const threshold = 0.1
	c := algo.NewcirCuitBreaker1(threshold)

	successCount := int(100 - 100*threshold - 1)
	failureBeforeFail := int(100*threshold - 1)

	require.Equal(t, 89, successCount)
	require.Equal(t, 9, failureBeforeFail)

	for i := 0; i <= successCount; i++ {
		c.Success(0)
	}

	require.True(t, c.Allow(), "expected breaker to be closed after success")

	for i := 0; i <= failureBeforeFail; i++ {
		c.Failure(0)
	}
	require.True(t, c.Allow(), "expected breaker to be closed if failure ratio is below threshold")

	c.Failure(0)

	require.False(t, c.Allow(), "expected breaker to be open after failure")
}

func TestOneRequestAfterOpenAndTimeout(t *testing.T) {
	after := make(chan time.Time)
	c := algo.NewcirCuitBreaker1ByConfig(&algo.CircuitBreaker1Config{
		FailureRatio: 0,
		After:        func(time.Duration) <-chan time.Time { return after },
	})

	require.True(t, c.Allow(), "expected new breaker to be closed")
	c.Failure(0)
	require.False(t, c.Allow(), "expected breaker to be open after failure")

	after <- time.Now()
	require.True(t, c.Allow(), "expected breaker to be closed after timeout")
	require.False(t, c.Allow(), "expected breaker to be open after one request")
}
