# 0379 Design Phone Directory

## Problem Description

Design a phone directory that initially has `maxNumbers` empty slots that can store numbers from 0 to `maxNumbers - 1`. Implement the `PhoneDirectory` class:

- `PhoneDirectory(int maxNumbers)` Initializes the phone directory with the maximum number of slots `maxNumbers`.
- `int get()` Provides a number that is not assigned to anyone.
- `bool check(int number)` Returns `true` if the slot `number` is available, and `false` otherwise.
- `void release(int number)` Recycles or releases the slot `number`.

### Example 1:
```
Input
["PhoneDirectory", "get", "get", "check", "get", "check", "release", "check"]
[[3], [], [], [2], [], [2], [2], [2]]
Output
[null, 0, 1, true, 2, false, null, true]

Explanation
PhoneDirectory phoneDirectory = new PhoneDirectory(3);
phoneDirectory.get();      // It can return any available number, here we return 0.
phoneDirectory.get();      // Assume it returns 1.
phoneDirectory.check(2);   // The number 2 is available, so return true.
phoneDirectory.get();      // It returns 2, the only number that is available.
phoneDirectory.check(2);   // The number 2 is no longer available, so return false.
phoneDirectory.release(2); // Release number 2 back to the pool.
phoneDirectory.check(2);   // Number 2 is available again, return true.
```

## The Twist

Implementing a phone directory that efficiently manages the allocation and deallocation of phone numbers with O(1) operations.

## Algorithm

### HashSet + Queue Approach:
1. Use a HashSet to track available numbers
2. Use a Queue to store numbers that have been released and can be reused
3. Initialize with all numbers from 0 to maxNumbers-1 in the available set
4. For get():
   - If the queue is not empty, dequeue and return a number
   - Otherwise, get the next available number from the set
   - Remove the number from the available set
5. For check(number):
   - Return true if the number is in the available set
6. For release(number):
   - If the number is not in the available set, add it back
   - Enqueue the number for future reuse

The key insight is using both a HashSet for O(1) availability checks and a Queue to efficiently reuse released numbers.

## Complexity

- **Time**: 
  - PhoneDirectory constructor: O(n) to initialize all numbers
  - get: O(1) amortized
  - check: O(1)
  - release: O(1)
- **Space**: O(n) where n is maxNumbers

## Solution Code

```go
package main

import "container/list"

type PhoneDirectory struct {
    available map[int]bool
    released  *list.List
    maxNumber int
}

func Constructor(maxNumbers int) PhoneDirectory {
    available := make(map[int]bool)
    for i := 0; i < maxNumbers; i++ {
        available[i] = true
    }
    
    return PhoneDirectory{
        available: available,
        released:  list.New(),
        maxNumber: maxNumbers,
    }
}

func (this *PhoneDirectory) Get() int {
    // First check if there are any released numbers to reuse
    if this.released.Len() > 0 {
        front := this.released.Front()
        number := front.Value.(int)
        this.released.Remove(front)
        delete(this.available, number)
        return number
    }
    
    // Otherwise, get the next available number
    for i := 0; i < this.maxNumber; i++ {
        if this.available[i] {
            delete(this.available, i)
            return i
        }
    }
    
    // No available numbers
    return -1
}

func (this *PhoneDirectory) Check(number int) bool {
    if number < 0 || number >= this.maxNumber {
        return false
    }
    return this.available[number]
}

func (this *PhoneDirectory) Release(number int) {
    if number < 0 || number >= this.maxNumber {
        return
    }
    
    // Only release if the number is currently in use
    if !this.available[number] {
        this.available[number] = true
        this.released.PushBack(number)
    }
}
```

## Link

[LeetCode 0379 Design Phone Directory](https://leetcode.com/problems/design-phone-directory/)