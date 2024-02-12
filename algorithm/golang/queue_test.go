package algo_test

import (
	"testing"

	"hungknow.com/algo"
)

func TestQueueEnqueue(t *testing.T) {
	q := algo.Queue[int]{}

	// Test Enqueue
	q.Enqueue(1)
	q.Enqueue(2)
	q.Enqueue(3)

	// Test IsEmpty
	if q.IsEmpty() {
		t.Errorf("IsEmpty() = true; want false")
	}

	// Test Dequeue
	expected := 1
	if data := q.Dequeue(); data != expected {
		t.Errorf("Dequeue() = %d; want %d", data, expected)
	}

	expected = 2
	if data := q.Dequeue(); data != expected {
		t.Errorf("Dequeue() = %d; want %d", data, expected)
	}

	expected = 3
	if data := q.Dequeue(); data != expected {
		t.Errorf("Dequeue() = %d; want %d", data, expected)
	}

	// Test IsEmpty after dequeueing all elements
	if !q.IsEmpty() {
		t.Errorf("IsEmpty() = false; want true")
	}
}

func TestQueueDequeueEmpty(t *testing.T) {
	q := algo.Queue[int]{}

	// Test Dequeue on empty queue
	defer func() {
		if r := recover(); r == nil {
			t.Errorf("Dequeue() did not panic on empty queue")
		}
	}()

	q.Dequeue()
}

func TestQueueIsEmpty(t *testing.T) {
	q := algo.Queue[int]{}

	// Test IsEmpty on empty queue
	if !q.IsEmpty() {
		t.Errorf("IsEmpty() = false; want true")
	}

	// Test IsEmpty after enqueueing an element
	q.Enqueue(1)
	if q.IsEmpty() {
		t.Errorf("IsEmpty() = true; want false")
	}
}