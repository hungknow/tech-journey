# 0380 Insert Delete GetRandom O(1)

## Problem Description

Implement the `RandomizedSet` class:

- `RandomizedSet()` Initializes the `RandomizedSet` object.
- `bool insert(int val)` Inserts an item `val` into the set if not present. Returns `true` if the item was not present, `false` otherwise.
- `bool remove(int val)` Removes an item `val` from the set if present. Returns `true` if the item was present, `false` otherwise.
- `int getRandom()` Returns a random element from the current set of elements (it's guaranteed that at least one element exists when this method is called). Each element must have the same probability of being returned.

You must implement the functions of the class such that each function works in average O(1) time complexity.

### Example 1:
```
Input
["RandomizedSet", "insert", "remove", "insert", "getRandom", "remove", "insert", "getRandom"]
[[], [1], [2], [2], [], [1], [2], []]
Output
[null, true, false, true, 2, true, false, 2]

Explanation
RandomizedSet randomizedSet = new RandomizedSet();
randomizedSet.insert(1); // Inserts 1 to the set. Returns true as 1 was inserted successfully.
randomizedSet.remove(2); // Returns false as 2 does not exist in the set.
randomizedSet.insert(2); // Inserts 2 to the set, returns true. Set now contains [1,2].
randomizedSet.getRandom(); // getRandom() should return either 1 or 2 randomly.
randomizedSet.remove(1); // Removes 1 from the set, returns true. Set now contains [2].
randomizedSet.insert(2); // 2 was already in the set, so return false.
randomizedSet.getRandom(); // Since 2 is the only number in the set, getRandom() will always return 2.
```

## The Twist

Implementing a data structure that supports insert, delete, and getRandom operations all in O(1) average time complexity.

## Algorithm

### HashMap + Array Approach:
1. Use an array to store the elements for O(1) random access
2. Use a HashMap to store the index of each element in the array for O(1) lookup
3. For insert(val):
   - Check if val exists in the HashMap
   - If not, add val to the end of the array and store its index in the HashMap
4. For remove(val):
   - Check if val exists in the HashMap
   - If yes, get the index of val
   - Move the last element of the array to the index of val
   - Update the HashMap with the new index of the moved element
   - Remove the last element from the array
   - Remove val from the HashMap
5. For getRandom():
   - Generate a random index between 0 and len(array)-1
   - Return the element at that index

The key insight is swapping the element to be removed with the last element to maintain O(1) deletion time.

## Complexity

- **Time**: 
  - insert: O(1) average
  - remove: O(1) average
  - getRandom: O(1)
- **Space**: O(n) where n is the number of elements in the set

## Solution Code

```go
package main

import "math/rand"

type RandomizedSet struct {
    nums   []int
    posMap map[int]int
}

func Constructor() RandomizedSet {
    return RandomizedSet{
        nums:   make([]int, 0),
        posMap: make(map[int]int),
    }
}

func (this *RandomizedSet) Insert(val int) bool {
    if _, exists := this.posMap[val]; exists {
        return false
    }
    
    this.posMap[val] = len(this.nums)
    this.nums = append(this.nums, val)
    return true
}

func (this *RandomizedSet) Remove(val int) bool {
    if _, exists := this.posMap[val]; !exists {
        return false
    }
    
    // Get the index of the element to remove
    idx := this.posMap[val]
    // Get the last element
    lastElement := this.nums[len(this.nums)-1]
    
    // Move the last element to the position of the element to remove
    this.nums[idx] = lastElement
    this.posMap[lastElement] = idx
    
    // Remove the last element
    this.nums = this.nums[:len(this.nums)-1]
    
    // Remove the element from the map
    delete(this.posMap, val)
    
    return true
}

func (this *RandomizedSet) GetRandom() int {
    randomIndex := rand.Intn(len(this.nums))
    return this.nums[randomIndex]
}
```

## Link

[LeetCode 0380 Insert Delete GetRandom O(1)](https://leetcode.com/problems/insert-delete-getrandom-o1/)