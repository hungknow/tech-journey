# 1825 Finding MK Average

## Problem Description

You are given a stream of integers and a window size `m`. For each new integer in the stream, you need to calculate the average of the last `m` integers, excluding the smallest and largest `k` numbers.

Implement the `MKAverage` class:

- `MKAverage(int m, int k)` Initializes the object with the window size `m` and the number of elements to exclude `k`.
- `void addElement(int num)` Inserts `num` into the stream.
- `int calculateMKAverage()` Returns the MK average of the last `m` elements.

The MK average is defined as the sum of the last `m` elements excluding the smallest and largest `k` elements, divided by `m - 2k`.

If there are fewer than `m` elements, return -1.

### Example 1:
```
Input
["MKAverage","addElement","addElement","addElement","addElement","addElement","calculateMKAverage","addElement","addElement","calculateMKAverage"]
[[3,1],[3],[1],[12],[5],[3],[],[8],[3],[8]]
Output
[null,null,null,null,null,null,8,null,null,8]

Explanation
MKAverage mkAverage = new MKAverage(3, 1);
mkAverage.addElement(3);        // stream: [3]
mkAverage.addElement(1);        // stream: [3,1]
mkAverage.addElement(12);       // stream: [3,1,12]
mkAverage.addElement(5);        // stream: [1,12,5]
mkAverage.addElement(3);        // stream: [12,5,3]
mkAverage.calculateMKAverage(); // return 8.0, which is (12+5+3)/(3-2*1) = 20/1 = 20
mkAverage.addElement(8);        // stream: [5,3,8]
mkAverage.addElement(3);        // stream: [3,8]
mkAverage.calculateMKAverage(); // return 8.0, which is (3+8)/(3-2*1) = 11/1 = 11
```

## The Twist

Implementing a data structure that efficiently maintains a sliding window and can quickly calculate the average excluding the k smallest and k largest elements.

## Algorithm

### Multiset + Queue Approach:
1. Use a queue to maintain the sliding window of size m
2. Use three multisets (or balanced BSTs) to track:
   - All elements in the current window
   - The k smallest elements
   - The k largest elements
3. For addElement(num):
   - Add num to the queue and to the main multiset
   - If queue size > m, remove the oldest element
   - Update the k smallest and k largest multisets accordingly
4. For calculateMKAverage():
   - If queue size < m, return -1
   - Calculate the sum of all elements minus the k smallest and k largest
   - Return sum / (m - 2k)

The key insight is using multisets to efficiently track and update the k smallest and k largest elements as the window slides.

## Complexity

- **Time**: 
  - MKAverage constructor: O(1)
  - addElement: O(logm) where m is the window size
  - calculateMKAverage: O(1)
- **Space**: O(m) where m is the window size

## Solution Code

```go
package main

import (
	"container/heap"
)

type MinHeap []int
type MaxHeap []int

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

func (h MaxHeap) Len() int           { return len(h) }
func (h MaxHeap) Less(i, j int) bool { return h[i] > h[j] }
func (h MaxHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *MaxHeap) Push(x interface{}) { *h = append(*h, x.(int)) }
func (h *MaxHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

type MKAverage struct {
	m       int
	k       int
	queue   []int
	sum     int
	minHeap *MinHeap
	maxHeap *MaxHeap
}

func Constructor(m int, k int) MKAverage {
	minHeap := &MinHeap{}
	maxHeap := &MaxHeap{}
	heap.Init(minHeap)
	heap.Init(maxHeap)
	
	return MKAverage{
		m:       m,
		k:       k,
		queue:   make([]int, 0),
		minHeap: minHeap,
		maxHeap: maxHeap,
	}
}

func (this *MKAverage) AddElement(num int)  {
	this.queue = append(this.queue, num)
	this.sum += num
	
	// Add to heaps
	heap.Push(this.minHeap, num)
	heap.Push(this.maxHeap, num)
	
	// If queue exceeds size m, remove oldest element
	if len(this.queue) > this.m {
		oldest := this.queue[0]
		this.queue = this.queue[1:]
		this.sum -= oldest
	}
	
	// Maintain heaps with at most k elements
	for this.minHeap.Len() > this.k {
		removed := heap.Pop(this.minHeap).(int)
		heap.Push(this.maxHeap, removed)
	}
	
	for this.maxHeap.Len() > this.k {
		removed := heap.Pop(this.maxHeap).(int)
		heap.Push(this.minHeap, removed)
	}
}

func (this *MKAverage) CalculateMKAverage() int {
	if len(this.queue) < this.m {
		return -1
	}
	
	// Calculate sum of elements excluding k smallest and k largest
	total := this.sum
	minSum := 0
	maxSum := 0
	
	// Sum of k smallest elements
	tempMinHeap := make(MinHeap, len(*this.minHeap))
	copy(tempMinHeap, *this.minHeap)
	for i := 0; i < this.k; i++ {
		minSum += heap.Pop(&tempMinHeap).(int)
	}
	
	// Sum of k largest elements
	tempMaxHeap := make(MaxHeap, len(*this.maxHeap))
	copy(tempMaxHeap, *this.maxHeap)
	for i := 0; i < this.k; i++ {
		maxSum += heap.Pop(&tempMaxHeap).(int)
	}
	
	result := total - minSum - maxSum
	return result / (this.m - 2*this.k)
}

/**
 * Your MKAverage object will be instantiated and called as such:
 * obj := Constructor(m, k);
 * obj.AddElement(num);
 * param_2 := obj.CalculateMKAverage();
 */
```

## Link

[LeetCode 1825 Finding MK Average](https://leetcode.com/problems/finding-mk-average/)