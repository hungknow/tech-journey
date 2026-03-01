# 0381 Insert Delete GetRandom O(1) - Duplicates allowed

## Problem Description

RandomizedCollection is a data structure that contains a collection of unique integers and supports all of the following operations in average O(1) time.

Note: Duplicates are allowed in the collection.

Implement the `RandomizedCollection` class:

- `RandomizedCollection()` Initializes the empty RandomizedCollection object.
- `bool insert(int val)` Inserts a value `val` into the collection. Returns `true` if the collection did not contain `val`, and `false` otherwise.
- `bool remove(int val)` Removes a value `val` from the collection. Returns `true` if the collection contained `val`, and `false` otherwise.
- `int getRandom()` Returns a random element from the current collection of elements. The probability of each element being returned is linearly related to the number of same value the collection contains.

### Example 1:
```
Input
["RandomizedCollection", "insert", "insert", "insert", "getRandom", "remove", "getRandom"]
[[], [1], [1], [2], [], [1], []]
Output
[null, true, false, true, 2, true, 1]

Explanation
RandomizedCollection collection = new RandomizedCollection();
collection.insert(1);   // return true since the collection does not contain 1.
                          // Inserts 1 into the collection.
collection.insert(1);   // return false since the collection contains 1.
                          // Inserts another 1 into the collection.
collection.insert(2);   // return true since the collection does not contain 2.
                          // Inserts 2 into the collection.
collection.getRandom(); // getRandom should:
                          // - return 1 with probability 2/3, or
                          // - return 2 with probability 1/3.
collection.remove(1);   // return true since the collection contains 1.
                          // Removes 1 from the collection.
collection.getRandom(); // getRandom should return 1 or 2, both with equal probability.
```

## The Twist

Implementing a data structure that supports insert, delete, and getRandom operations all in O(1) average time complexity, while allowing duplicate elements.

## Algorithm

### HashMap + Array Approach with Index Tracking:
1. Use an array to store all elements (including duplicates) for O(1) random access
2. Use a HashMap to store a set of indices where each value appears in the array
3. For insert(val):
   - Add val to the end of the array
   - Add the new index to the set of indices for val in the HashMap
   - Return true if it's the first occurrence, false otherwise
4. For remove(val):
   - Check if val exists in the HashMap
   - If yes, get any index from the set of indices for val
   - Get the last element from the array
   - Move the last element to the index of the element to remove
   - Update the HashMap:
     - Remove the index of the removed element from val's set
     - Update the index of the moved element in its set
   - Remove the last element from the array
   - If val's set becomes empty, remove val from the HashMap
5. For getRandom():
   - Generate a random index between 0 and len(array)-1
   - Return the element at that index

The key insight is tracking all indices for each value and efficiently updating them during removal operations.

## Complexity

- **Time**: 
  - insert: O(1) average
  - remove: O(1) average
  - getRandom: O(1)
- **Space**: O(n) where n is the total number of elements in the collection

## Solution Code

```go
package main

import (
	"math/rand"
)

type RandomizedCollection struct {
	nums   []int
	posMap map[int]map[int]struct{}
}

func Constructor() RandomizedCollection {
	return RandomizedCollection{
		nums:   make([]int, 0),
		posMap: make(map[int]map[int]struct{}),
	}
}

func (this *RandomizedCollection) Insert(val int) bool {
	isFirst := false
	if _, exists := this.posMap[val]; !exists {
		this.posMap[val] = make(map[int]struct{})
		isFirst = true
	}
	
	this.nums = append(this.nums, val)
	this.posMap[val][len(this.nums)-1] = struct{}{}
	
	return isFirst
}

func (this *RandomizedCollection) Remove(val int) bool {
	if _, exists := this.posMap[val]; !exists {
		return false
	}
	
	// Get an arbitrary index of val
	idxToRemove := -1
	for idx := range this.posMap[val] {
		idxToRemove = idx
		break
	}
	
	// Get the last element
	lastElement := this.nums[len(this.nums)-1]
	lastIdx := len(this.nums) - 1
	
	// Move the last element to the position of the element to remove
	this.nums[idxToRemove] = lastElement
	
	// Update the position map
	delete(this.posMap[val], idxToRemove)
	if len(this.posMap[val]) == 0 {
		delete(this.posMap, val)
	}
	
	// Update the position of the last element
	if idxToRemove != lastIdx {
		delete(this.posMap[lastElement], lastIdx)
		this.posMap[lastElement][idxToRemove] = struct{}{}
	}
	
	// Remove the last element
	this.nums = this.nums[:lastIdx]
	
	return true
}

func (this *RandomizedCollection) GetRandom() int {
	randomIndex := rand.Intn(len(this.nums))
	return this.nums[randomIndex]
}
```

## Link

[LeetCode 0381 Insert Delete GetRandom O(1) - Duplicates allowed](https://leetcode.com/problems/insert-delete-getrandom-o1-duplicates-allowed/)