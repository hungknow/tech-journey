# 1845 Seat Reservation Manager

## Problem Description

Design a system that manages the reservation of seats in a concert hall with `n` numbered seats from 1 to `n`.

Implement the `SeatManager` class:

- `SeatManager(int n)` Initializes the object with `n` seats.
- `int reserve()` Reserves the seat with the smallest number and returns it.
- `void unreserve(int seatNumber)` Unreserves the seat with the given seatNumber.

### Example 1:
```
Input
["SeatManager","reserve","reserve","unreserve","reserve","reserve","reserve","unreserve","reserve"]
[[5],[],[],[2],[],[],[],[5],[]]
Output
[null,1,2,null,3,4,5,null,1]

Explanation
SeatManager seatManager = new SeatManager(5);
seatManager.reserve();    // Reserve seat 1, returns 1.
seatManager.reserve();    // Reserve seat 2, returns 2.
seatManager.unreserve(2); // Unreserve seat 2.
seatManager.reserve();    // Reserve seat 1, returns 1.
seatManager.reserve();    // Reserve seat 3, returns 3.
seatManager.reserve();    // Reserve seat 4, returns 4.
seatManager.unreserve(5); // Unreserve seat 5.
seatManager.reserve();    // Reserve seat 1, returns 1.
```

## The Twist

Implementing a seat reservation system that efficiently manages seat allocation and deallocation with priority on the smallest numbered available seat.

## Algorithm

### Min-Heap Approach:
1. Use a min-heap to track available seats
2. For SeatManager(n):
   - Initialize the heap with all seat numbers from 1 to n
3. For reserve():
   - Extract the minimum seat number from the heap
   - Return this seat number
4. For unreserve(seatNumber):
   - Add the seat number back to the heap

The key insight is using a min-heap to efficiently always reserve the smallest available seat number.

## Complexity

- **Time**: 
  - SeatManager constructor: O(n) where n is the number of seats
  - reserve: O(logn) where n is the number of seats
  - unreserve: O(logn) where n is the number of seats
- **Space**: O(n) where n is the number of seats

## Solution Code

```go
package main

import "container/heap"

type MinHeap []int

func (h MinHeap) Len() int           { return len(h) }
func (h MinHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h MinHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *MinHeap) Push(x interface{}) { *h = append(*h, x.(int)) }
func (h *MinHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

type SeatManager struct {
	availableSeats *MinHeap
}

func Constructor(n int) SeatManager {
	// Initialize min-heap with all seat numbers
	availableSeats := &MinHeap{}
	heap.Init(availableSeats)
	
	for i := 1; i <= n; i++ {
		heap.Push(availableSeats, i)
	}
	
	return SeatManager{
		availableSeats: availableSeats,
	}
}

func (this *SeatManager) Reserve() int {
	// Extract the smallest available seat
	seat := heap.Pop(this.availableSeats).(int)
	return seat
}

func (this *SeatManager) Unreserve(seatNumber int)  {
	// Add the seat back to the heap
	heap.Push(this.availableSeats, seatNumber)
}

/**
 * Your SeatManager object will be instantiated and called as such:
 * obj := Constructor(n);
 * param_1 := obj.Reserve();
 * param_2 := obj.Unreserve(seatNumber);
 */
```

## Link

[LeetCode 1845 Seat Reservation Manager](https://leetcode.com/problems/seat-reservation-manager/)