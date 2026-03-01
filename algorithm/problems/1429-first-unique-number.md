# 1429 First Unique Number

## Problem Description

You have a queue of integers, you need to retrieve the first unique integer in the queue.

Implement the `FirstUnique` class:

- `FirstUnique(int[] nums)` Initializes the object with the numbers in the queue.
- `int showFirstUnique()` Returns the value of the first unique integer in the queue, and returns -1 if there is no such integer.
- `void add(int value)` Insert value to the queue.

### Example 1:
```
Input
["FirstUnique", "showFirstUnique", "add", "showFirstUnique", "add", "showFirstUnique", "add", "showFirstUnique"]
[[[2,3,5]], [], [5], [], [2], [], [3], []]
Output
[null, 2, null, 2, null, 3, null, -1]

Explanation
FirstUnique firstUnique = new FirstUnique([2,3,5]);
firstUnique.showFirstUnique(); // return 2
firstUnique.add(5);            // the queue is now [2,3,5,5]
firstUnique.showFirstUnique(); // return 2
firstUnique.add(2);            // the queue is now [2,3,5,5,2]
firstUnique.showFirstUnique(); // return 3
firstUnique.add(3);            // the queue is now [2,3,5,5,2,3]
firstUnique.showFirstUnique(); // return -1
```

## The Twist

Implementing a data structure that can efficiently track the first unique number in a dynamic queue. The challenge is to maintain order while quickly identifying unique elements.

## Algorithm

### LinkedHashMap + HashSet Approach:
1. Use a LinkedHashMap to maintain insertion order of all numbers
2. Use a HashSet to track numbers that have appeared more than once
3. For initialization:
   - Add all numbers to the LinkedHashMap
   - Track duplicates in the HashSet
4. For showFirstUnique():
   - Iterate through the LinkedHashMap to find the first number not in the duplicate set
   - Return that number or -1 if none found
5. For add(value):
   - If value is already in the duplicate set, do nothing
   - If value is in LinkedHashMap:
     - Remove it from LinkedHashMap
     - Add it to duplicate set
   - If value is new:
     - Add it to LinkedHashMap

The key insight is using LinkedHashMap to maintain order while efficiently checking for uniqueness.

## Complexity

- **Time**: 
  - Constructor: O(n) where n is the number of initial elements
  - showFirstUnique: O(n) in worst case (need to iterate through map)
  - add: O(1) average case
- **Space**: O(n) where n is the number of unique elements

## Solution Code

```go
package main

import "container/list"

type FirstUnique struct {
    queue     *list.List
    valueMap  map[int]*list.Element
    duplicate map[int]bool
}

func Constructor(nums []int) FirstUnique {
    queue := list.New()
    valueMap := make(map[int]*list.Element)
    duplicate := make(map[int]bool)
    
    for _, num := range nums {
        if _, exists := duplicate[num]; exists {
            continue
        }
        
        if _, exists := valueMap[num]; exists {
            // Remove from queue and mark as duplicate
            queue.Remove(valueMap[num])
            delete(valueMap, num)
            duplicate[num] = true
        } else {
            // Add to queue
            element := queue.PushBack(num)
            valueMap[num] = element
        }
    }
    
    return FirstUnique{
        queue:     queue,
        valueMap:  valueMap,
        duplicate: duplicate,
    }
}

func (this *FirstUnique) ShowFirstUnique() int {
    if this.queue.Len() == 0 {
        return -1
    }
    
    if element := this.queue.Front(); element != nil {
        return element.Value.(int)
    }
    
    return -1
}

func (this *FirstUnique) Add(value int)  {
    if _, exists := this.duplicate[value]; exists {
        return
    }
    
    if element, exists := this.valueMap[value]; exists {
        // Remove from queue and mark as duplicate
        this.queue.Remove(element)
        delete(this.valueMap, value)
        this.duplicate[value] = true
    } else {
        // Add to queue
        element := this.queue.PushBack(value)
        this.valueMap[value] = element
    }
}
```

## Link

[LeetCode 1429 First Unique Number](https://leetcode.com/problems/first-unique-number/)