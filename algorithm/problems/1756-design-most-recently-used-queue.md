# 1756 Design Most Recently Used Queue

## Problem Description

Design a queue-like data structure that supports the standard queue operations and also tracks the most recently used element.

Implement the `MRUQueue` class:

- `MRUQueue(int capacity)` Initializes the queue with the given capacity.
- `int fetch(int k)` Moves the kth element (1-indexed) from the front of the queue to the end of the queue and returns it.

### Example 1:
```
Input
["MRUQueue","fetch","fetch","fetch","fetch"]
[[8],[3],[5],[2],[8]]
Output
[null,2,6,8,8]

Explanation
MRUQueue mruQueue = new MRUQueue(8); // Initializes the queue to [2,3,4,5,6,7,8].
mruQueue.fetch(3); // Moves the 3rd element (5) to the end of the queue.
                    // Queue becomes [2,3,4,6,7,8,5].
mruQueue.fetch(5); // Moves the 5th element (8) to the end of the queue.
                    // Queue becomes [2,3,4,6,7,5,8].
mruQueue.fetch(2); // Moves the 2nd element (3) to the end of the queue.
                    // Queue becomes [2,4,6,7,5,8,3].
mruQueue.fetch(8); // The 8th element doesn't exist, so the queue remains unchanged.
```

## The Twist

Implementing a queue-like structure that efficiently supports moving the kth element from the front to the end while maintaining the order of other elements.

## Algorithm

### Array + Index Tracking Approach:
1. Use an array to store the queue elements
2. For MRUQueue(capacity):
   - Initialize the array with elements from 1 to capacity
3. For fetch(k):
   - If k is out of bounds, return the last element
   - Remove the kth element from its position
   - Append it to the end of the array
   - Return the removed element

The key insight is using a simple array to represent the queue and directly manipulating elements based on their positions.

## Complexity

- **Time**: 
  - MRUQueue constructor: O(n) where n is the capacity
  - fetch: O(n) where n is the size of the queue (due to array shifting)
- **Space**: O(n) where n is the capacity

## Solution Code

```go
package main

type MRUQueue struct {
	queue    []int
	capacity int
}

func Constructor(capacity int) MRUQueue {
	// Initialize with elements from 1 to capacity
	queue := make([]int, capacity)
	for i := 0; i < capacity; i++ {
		queue[i] = i + 1
	}
	
	return MRUQueue{
		queue:    queue,
		capacity: capacity,
	}
}

func (this *MRUQueue) Fetch(k int) int {
	if k <= 0 || k > len(this.queue) {
		return this.queue[len(this.queue)-1]
	}
	
	// Get the kth element (1-indexed)
	element := this.queue[k-1]
	
	// Remove the kth element
	this.queue = append(this.queue[:k-1], this.queue[k:]...)
	
	// Append it to the end
	this.queue = append(this.queue, element)
	
	return element
}

/**
 * Your MRUQueue object will be instantiated and called as such:
 * obj := Constructor(capacity);
 * param_1 := obj.Fetch(k);
 */
```

## Link

[LeetCode 1756 Design Most Recently Used Queue](https://leetcode.com/problems/design-most-recently-used-queue/)