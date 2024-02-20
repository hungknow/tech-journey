package algo

import (
	"container/ring"
	"time"
)

// Document: https://learn.microsoft.com/en-us/previous-versions/msp-n-p/dn589784(v=pandp.10)?redirectedfrom=MSDN

const (
	// DefaultWindow is the default number of per-second buckets that will be
	// considered when calculating metrics on the circuit breaker.
	circuitBreakerDefaultWindow = 5 * time.Second

	// DefaultCooldown is the default period a circuit will remain in the open
	// state before allowing a single sentinel request through.
	circuitBreakerDefaultCooldown = 1 * time.Second

	// DefaultMinObservations is the default number of observations that must
	// be made before the circuit breaker
	circuitBreakerDefaultMinObservations = 10
)

type CircuitBreaker interface {
	Allow() bool
	Success(time.Duration)
	Failure(time.Duration)
}

type circuitBreakerState int

const (
	reset circuitBreakerState = iota
	tripped
	closed
	open
	halfopen
)

type circuitBreaker1 struct {
	force   chan circuitBreakerState
	allow   chan bool
	success chan time.Duration
	failure chan time.Duration
	config  *CircuitBreaker1Config
}

type CircuitBreaker1Config struct {
	FailureRatio    float64
	Window          time.Duration                        // number of second buckets to observe
	CoolDown        time.Duration                        // time to wait before trying once when open
	MinObservations uint                                 // observations required to open when failing
	Now             func() time.Time                     // default time.Now
	After           func(time.Duration) <-chan time.Time // default time.After
}

func NewcirCuitBreaker1ByConfig(config *CircuitBreaker1Config) *circuitBreaker1 {
	if config.FailureRatio < 0.0 {
		config.FailureRatio = 0.0
	}

	if config.FailureRatio > 1.0 {
		config.FailureRatio = 1.0
	}

	if config.Window == 0 {
		config.Window = circuitBreakerDefaultWindow
	}

	if config.CoolDown == 0 {
		config.CoolDown = circuitBreakerDefaultCooldown
	}

	if config.Now == nil {
		config.Now = time.Now
	}

	if config.After == nil {
		config.After = time.After
	}
	c := circuitBreaker1{
		force:   make(chan circuitBreakerState),
		allow:   make(chan bool),
		success: make(chan time.Duration),
		failure: make(chan time.Duration),
		config:  config,
	}
	go c.run()
	return &c
}

func NewcirCuitBreaker1(failureRatio float64) *circuitBreaker1 {
	return NewcirCuitBreaker1ByConfig(&CircuitBreaker1Config{
		FailureRatio: failureRatio,
		Window:       circuitBreakerDefaultWindow,
		CoolDown:     circuitBreakerDefaultCooldown,
	})
}

func (c circuitBreaker1) Success(d time.Duration) {
	c.success <- d
}

func (c circuitBreaker1) Failure(d time.Duration) {
	c.failure <- d
}

func (c circuitBreaker1) Allow() bool {
	return <-c.allow
}

func (c circuitBreaker1) trip() {
	c.force <- tripped
}

var ExportCircuitBreaker1Trip = (*circuitBreaker1).trip

func (c circuitBreaker1) Reset() {
	c.force <- reset
}

func (c circuitBreaker1) shouldOpen(m *metric) bool {
	s := m.Summary()
	return s.total > c.config.MinObservations && s.rate > c.config.FailureRatio
}

func (c circuitBreaker1) run() {
	var (
		state   circuitBreakerState
		timeout <-chan time.Time
		metrics *metric
	)
	for {
		switch state {
		case reset:
			metrics = newMetric(10*time.Second, time.Now)
			timeout = nil
			state = closed
		case closed:
			select {
			case c.allow <- true:
			case d := <-c.success:
				metrics.Success(d)
			case d := <-c.failure:
				metrics.Failure(d)
				if c.shouldOpen(metrics) {
					state = tripped
				}
			case state = <-c.force:
			}

		case tripped:
			timeout = c.config.After(c.config.CoolDown)
			state = open
		case open:
			select {
			case c.allow <- false:
			case <-c.success:
				state = reset
			case <-c.failure:
			case <-timeout:
				state = halfopen
			case state = <-c.force:
			}
		case halfopen:
			select {
			case c.allow <- true:
				state = tripped
			case <-c.success:
				state = reset
			case <-c.failure:
				state = tripped
			case state = <-c.force:
			}
		}
	}
}

type metricCounter struct {
	second  int64
	success uint
	failure uint
}

func (m *metricCounter) Reset(second int64) {
	m.second = second
	m.success = 0
	m.failure = 0
}

type metricSummary struct {
	total  uint
	errors uint
	rate   float64
}

type metric struct {
	r       *ring.Ring
	seconds uint
	now     func() time.Time
}

func newMetric(window time.Duration, now func() time.Time) *metric {
	seconds := int(window / time.Second)

	r := ring.New(seconds)
	for i := 0; i < seconds; i++ {
		r.Value = &metricCounter{}
		r = r.Next()
	}

	return &metric{
		r:       r,
		seconds: uint(seconds),
		now:     now,
	}
}

func (m *metric) next() *metricCounter {
	bucket := m.now().Unix()
	c := m.r.Value.(*metricCounter)
	if c.second != bucket {
		step := bucket - c.second
		if step < 0 || step > int64(m.seconds) {
			step = int64(m.seconds)
			for i := int64(1); i <= step; i++ {
				m.r = m.r.Next()
				c = m.r.Value.(*metricCounter)
				c.Reset(bucket - step + i)
			}
		}
	}
	return m.r.Value.(*metricCounter)
}

func (m *metric) Success(time.Duration) {
	m.next().success++
}

func (m *metric) Failure(time.Duration) {
	m.next().failure++
}

func (m *metric) Summary() metricSummary {
	var sum metricSummary

	m.r.Do(func(p interface{}) {
		c := p.(*metricCounter)
		sum.total += c.success + c.failure
		sum.errors += c.failure
	})

	if sum.total > 0 {
		sum.rate = float64(sum.errors) / float64(sum.total)
	}

	return sum
}
