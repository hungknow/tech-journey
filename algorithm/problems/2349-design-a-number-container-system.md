# 2349 Design a Number Container System

## Problem Description

Design a number container system that supports the following operations:

- `NumberContainers()` Initializes the object with empty containers.
- `void change(int index, int number)` Changes the number at index `index` to `number`.
- `int find(int number)` Returns the index of the container that contains the given number, or -1 if not found.

### Example 1:
```
Input
["NumberContainers","change","find","find","find","find"]
[[],[10],[2,10],[1,10]]
Output
[null,1,2]

Explanation
NumberContainers nc = new NumberContainers();
nc.change(1, 10); // container is now [10]
nc.find(10);    // return 1, index 1 contains 10
nc.find(10);    // return 2, index 2 contains 10
```

## The Twist

Implementing a number container system that efficiently tracks numbers and supports updates and lookups.

## Algorithm

### HashMap + TreeSet Approach:
1. Use a HashMap to map numbers to their indices
2. Use a TreeSet (or balanced BST) to maintain sorted numbers
3. For NumberContainers():
   - Initialize empty data structures
4. For change(index, number):
   - Update the HashMap and TreeSet
5. For find(number):
   - Return the index from the HashMap, or -1 if not found

The key insight is using both a HashMap for O(1) lookups and a TreeSet for O(logn) updates.

## Complexity

- **Time**: 
  - NumberContainers constructor: O(1)
  - change: O(logn) where n is the number of unique numbers
  - find: O(1) for HashMap lookup
- **Space**: O(n) where n is the number of unique numbers

## Solution Code

```go
package main

import (
	"sort"
)

type NumberContainers struct {
	numToIndex map[int]int
	sorted    []int
}

func Constructor() NumberContainers {
	return NumberContainers{
		numToIndex: make(map[int]int),
		sorted:    make([]int, 0),
	}
}

func (this *NumberContainers) Change(index int, number int) {
	if _, exists := this.numToIndex[index]; exists {
		// Remove old index
		delete(this.numToIndex, index)
	}
	
	// Add new index
	this.numToIndex[index] = number
	
	// Update sorted list
	insertPos := sort.SearchInts(this.sorted, number)
	if insertPos == len(this.sorted) {
		this.sorted = append(this.sorted, number)
	} else {
		// Insert at the correct position
		this.sorted = append(this.sorted[:insertPos], append([]int{number}, this.sorted[insertPos:]...)...)
	}
}

func (this *NumberContainers) Find(number int) int {
	if index, exists := this.numToIndex[number]; exists {
		return index
	}
	
	return -1
}

/**
 * Your NumberContainers object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Change(index,number);
 * param_2 := obj.Find(number);
 */
```

## Link

[LeetCode 2349 Design a Number Container System](https://leetcode.com/problems/design-a-number-container-system/)