package algo_test

import (
	"testing"

	"hungknow.com/algo"
)

func TestLinkedList(t *testing.T) {
	ll := algo.NewLinkedList()

	// Test Insert and Display
	ll.Insert(1)
	ll.Insert(2)
	ll.Insert(3)
	expected := "3 -> 2 -> 1"
	if ll.Display() != expected {
		t.Errorf("Display() = %s; want %s", ll.Display(), expected)
	}

	// Test InsertAtIndex and Display
	ll.InsertAtIndex(4, 1)
	expected = "3 -> 4 -> 2 -> 1"
	if ll.Display() != expected {
		t.Errorf("Display() = %s; want %s", ll.Display(), expected)
	}

	// Test RemoveAtIndex and Display
	ll.RemoveAtIndex(2)
	expected = "3 -> 4 -> 1"
	if ll.Display() != expected {
		t.Errorf("Display() = %s; want %s", ll.Display(), expected)
	}

	// Test IsEmpty
	if ll.IsEmpty() {
		t.Errorf("IsEmpty() = true; want false")
	}

	// Test Size
	size := ll.Size()
	if size != 3 {
		t.Errorf("Size() = %d; want 3", size)
	}
		
}
