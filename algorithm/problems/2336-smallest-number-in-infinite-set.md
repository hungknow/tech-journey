# 2336 Smallest Number in Infinite Set

## Problem Description

Design a data structure that supports the following operations:

- `SmallestInfiniteSet()` Initializes the object with an empty set.
- `int popSmallest()` Removes and returns the smallest number from the set.
- `void addBack(int num)` Adds `num` back to the set.

### Example 1:
```
Input
["SmallestInfiniteSet","popSmallest","addBack","popSmallest","popSmallest","addBack"]
[[],[2],[1],[2],[1]]
Output
[null,2,1]

Explanation
SmallestInfiniteSet s = new SmallestInfiniteSet();
s.addBack(1);      // add 1 back to set
s.addBack(2);      // add 2 back to set
s.popSmallest();  // return 1, smallest number is 1
s.popSmallest();  // return 2, smallest number is 2
s.addBack(1);      // add 1 back to set
s.popSmallest();  // return 1, smallest number is 1
```

## The Twist

Implementing a data structure that efficiently returns the smallest number from an infinite set with support for adding back numbers.

## Algorithm

### Min-Heap Approach:
1. Use a min-heap to store the numbers in the set
2. For SmallestInfiniteSet():
   - Initialize an empty min-heap
3. For popSmallest():
   - Extract and return the smallest number
4. For addBack(num):
   - Add the number back to the heap

The key insight is using a min-heap to efficiently maintain and retrieve the smallest element.

## Complexity

- **Time**: 
  - SmallestInfiniteSet constructor: O(1)
  - popSmallest: O(logn) where n is the size of the heap
  - addBack: O(logn) where n is the size of the heap
- **Space**: O(n) where n is the size of the heap

## Solution Code

```go
package main

import "container/heap"

type SmallestInfiniteSet struct {
	heap *IntHeap
}

func Constructor() SmallestInfiniteSet {
	heap := &IntHeap{}
	heap.Init(heap)
	
	return SmallestInfiniteSet{
		heap: heap,
	}
}

func (this *SmallestInfiniteSet) PopSmallest() int {
	if this.heap.Len() == 0 {
		return -1
	}
	
	return heap.Pop(this.heap).(int)
}

func (this *SmallestInfiniteSet) AddBack(num int)  {
	heap.Push(this.heap, num)
}

/**
 * Your SmallestInfiniteSet object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.PopSmallest();
 * param_2 := obj.AddBack(num);
 */
```

## Link

[LeetCode 2336 Smallest Number in Infinite Set](https://leetcode.com/problems/smallest-number-in-infinite-set/)