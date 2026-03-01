# 1172 Dinner Plate Stacks

## Problem Description

You have an infinite number of stacks arranged in a row and numbered (left to right) from 0 to infinity. Each stack has a maximum capacity.

Implement the `DinnerPlates` class:

- `DinnerPlates(int capacity)` Initializes the object with the maximum capacity of the stacks.
- `void push(int val)` Pushes the given integer `val` onto the leftmost stack with size less than `capacity`.
- `int pop()` Returns the value at the top of the rightmost non-empty stack and removes it from that stack, and returns -1 if all stacks are empty.
- `int popAtStack(int index)` Returns the value at the top of the stack with the given `index` and removes it from that stack, and returns -1 if the stack with the given `index` is empty.

### Example 1:
```
Input
["DinnerPlates", "push", "push", "push", "push", "push", "popAtStack", "push", "push", "popAtStack", "popAtStack", "pop", "pop", "pop", "pop", "pop"]
[[2], [1], [2], [3], [4], [5], [0], [20], [21], [0], [2], [], [], [], [], []]
Output
[null, null, null, null, null, null, 2, null, null, 20, 21, 5, 4, 3, 1, -1]

Explanation:
DinnerPlates D = DinnerPlates(2);  // Initialize with capacity = 2
D.push(1);
D.push(2);
D.push(3);
D.push(4);
D.push(5);         // The stacks are now:  1  2  3  4  5
D.popAtStack(0);   // Pop from stack 0: 2. The stacks are now:     3  4  5
D.push(20);        // Push 20 to the leftmost stack: 20  3  4  5
D.push(21);        // Push 21 to the leftmost stack: 20  21  3  4  5
D.popAtStack(0);   // Pop from stack 0: 21. The stacks are now: 20  3  4  5
D.popAtStack(2);   // Pop from stack 2: 4. The stacks are now: 20  3  5
D.pop();           // Pop from the rightmost non-empty stack: 5. Stacks are: 20  3
D.pop();           // Pop from the rightmost non-empty stack: 3. Stacks are: 20
D.pop();           // Pop from the rightmost non-empty stack: 20. Stacks are: []
D.pop();           // All stacks are empty. Return -1.
```

## The Twist

Managing an infinite number of stacks with efficient operations for push, pop, and popAtStack. The challenge is to track available stacks and handle gaps efficiently.

## Algorithm

### Min-Heap + Stacks Approach:
1. Use a min-heap to track indices of available stacks (those with space)
2. Use a list of stacks to store the actual data
3. Use a variable to track the rightmost non-empty stack
4. For push(val):
   - If heap is empty, create a new stack at the end
   - Get the leftmost available stack index from heap
   - Push val onto that stack
   - If stack becomes full, remove it from heap
5. For pop():
   - Find the rightmost non-empty stack
   - Pop from it and return the value
   - If stack becomes empty after pop, update rightmost pointer
   - Add stack index back to heap if it now has space
6. For popAtStack(index):
   - Check if index is valid and stack is not empty
   - Pop from the specified stack and return value
   - Add index back to heap since it now has space

The key insight is using a min-heap to efficiently find the leftmost available stack for push operations.

## Complexity

- **Time**: 
  - push: O(log n) - heap operations
  - pop: O(1) amortized
  - popAtStack: O(log n) - heap operations
- **Space**: O(n) where n is the total number of elements

## Solution Code

```go
package main

import (
    "container/heap"
)

type MinHeap []int

func (h MinHeap) Len() int           { return len(h) }
func (h MinHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h MinHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MinHeap) Push(x interface{}) {
    *h = append(*h, x.(int))
}

func (h *MinHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}

type DinnerPlates struct {
    capacity int
    stacks   [][]int
    available *MinHeap
    rightmost int
}

func Constructor(capacity int) DinnerPlates {
    available := &MinHeap{}
    heap.Init(available)
    
    return DinnerPlates{
        capacity:  capacity,
        stacks:    make([][]int, 0),
        available: available,
        rightmost: -1,
    }
}

func (this *DinnerPlates) Push(val int)  {
    // Find leftmost available stack
    var stackIndex int
    if this.available.Len() > 0 {
        stackIndex = heap.Pop(this.available).(int)
    } else {
        stackIndex = len(this.stacks)
        this.stacks = append(this.stacks, make([]int, 0))
    }
    
    // Push value to the stack
    if stackIndex >= len(this.stacks) {
        this.stacks = append(this.stacks, make([]int, 0))
    }
    this.stacks[stackIndex] = append(this.stacks[stackIndex], val)
    
    // Update rightmost if needed
    if stackIndex > this.rightmost {
        this.rightmost = stackIndex
    }
    
    // If stack is not full, add back to available
    if len(this.stacks[stackIndex]) < this.capacity {
        heap.Push(this.available, stackIndex)
    }
}

func (this *DinnerPlates) Pop() int {
    // Find rightmost non-empty stack
    for this.rightmost >= 0 {
        if this.rightmost < len(this.stacks) && len(this.stacks[this.rightmost]) > 0 {
            break
        }
        this.rightmost--
    }
    
    if this.rightmost < 0 {
        return -1
    }
    
    // Pop from rightmost stack
    stack := this.stacks[this.rightmost]
    val := stack[len(stack)-1]
    this.stacks[this.rightmost] = stack[:len(stack)-1]
    
    // Add stack index back to available since it now has space
    heap.Push(this.available, this.rightmost)
    
    return val
}

func (this *DinnerPlates) PopAtStack(index int) int {
    if index < 0 || index >= len(this.stacks) || len(this.stacks[index]) == 0 {
        return -1
    }
    
    // Pop from specified stack
    stack := this.stacks[index]
    val := stack[len(stack)-1]
    this.stacks[index] = stack[:len(stack)-1]
    
    // Add stack index back to available since it now has space
    heap.Push(this.available, index)
    
    return val
}
```

## Link

[LeetCode 1172 Dinner Plate Stacks](https://leetcode.com/problems/dinner-plate-stacks/)