package algo_test

import (
	"fmt"
	"testing"
	"time"
)

func TestChannel(t *testing.T) {
	// create channel
	ch := make(chan int)
	timeout := time.NewTimer(2 * time.Second)

	// go func() {
	// 	// for {
	// 	<-ch
	// 	fmt.Printf("BLOCK")
	// 	// }
	// }()

	select {
	case ch <- 1:
	case <-timeout.C:
		fmt.Println("TIMEOUT")
	}

	fmt.Println("NOT BLOCK")

	value := <-ch
	fmt.Printf("Receive value in channel: %d\n", value)
}
