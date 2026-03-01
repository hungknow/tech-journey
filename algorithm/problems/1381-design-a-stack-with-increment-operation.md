# 1381 Design a Stack With Increment Operation

## Problem Description

Design a stack which supports the following operations.

Implement the `CustomStack` class:

- `CustomStack(int maxSize)` Initializes the object with maxSize which is the maximum number of elements in the stack or do nothing if the stack reached the maxSize.
- `void push(int x)` Adds x to the top of the stack if the stack hasn't reached the maxSize.
- `int pop()` Pops and returns the top of stack if the stack is not empty, return -1 otherwise.
- `void inc(int k, int val)` Increments the bottom k elements of the stack by val. If there are less than k elements in the stack, just increment all the elements in the stack.

### Example 1:
```
Input
["CustomStack","push","push","pop","push","push","push","increment","increment","pop","pop","pop","pop"]
[[3],[1],[2],[],[2],[3],[4],[5,100],[2,100],[],[],[],[]]
Output
[null,null,null,2,null,null,null,null,null,103,202,201,-1]

Explanation
CustomStack customStack = new CustomStack(3); // Stack is Empty []
customStack.push(1);                          // stack becomes [1]
customStack.push(2);                          // stack becomes [1, 2]
customStack.pop();                            // return 2 -> Return top of the stack 2, stack becomes [1]
customStack.push(2);                          // stack becomes [1, 2]
customStack.push(3);                          // stack becomes [1, 2, 3]
customStack.push(4);                          // stack still [1, 2, 3], stack is full
customStack.increment(5, 100);                // stack becomes [101, 102, 103]
customStack.increment(2, 100);                // stack becomes [201, 202, 103]
customStack.pop();                            // return 103 -> Return top of the stack 103, stack becomes [201, 202]
customStack.pop();                            // return 202 -> Return top of the stack 202, stack becomes [201]
customStack.pop();                            // return 201 -> Return top of the stack 201, stack becomes []
customStack.pop();                            // return -1 -> Stack is empty return -1.
```

## The Twist

Implementing a stack that supports efficient increment operations on the bottom k elements. The challenge is to perform increment operations in O(1) time rather than O(k).

## Algorithm

### Lazy Increment Approach:
1. Use a stack to store elements
2. Use an additional array to track pending increments for each position
3. For push(x):
   - If stack is not full, push x to stack
4. For pop():
   - If stack is empty, return -1
   - Get the top element and its pending increment
   - Apply the pending increment to the element
   - If there's an element below, add the increment to its pending value
   - Return the element with applied increment
5. For inc(k, val):
   - If stack is empty, do nothing
   - Add val to the pending increment of the k-th element from bottom (or bottom element if k > stack size)

The key insight is using lazy propagation: we store increments and apply them only when elements are actually popped.

## Complexity

- **Time**: 
  - push: O(1)
  - pop: O(1)
  - inc: O(1)
- **Space**: O(maxSize) - storing stack and pending increments

## Solution Code

```go
package main

type CustomStack struct {
    stack        []int
    increments   []int
    maxSize      int
}

func Constructor(maxSize int) CustomStack {
    return CustomStack{
        stack:      make([]int, 0),
        increments: make([]int, 0),
        maxSize:    maxSize,
    }
}

func (this *CustomStack) Push(x int)  {
    if len(this.stack) < this.maxSize {
        this.stack = append(this.stack, x)
        this.increments = append(this.increments, 0)
    }
}

func (this *CustomStack) Pop() int {
    if len(this.stack) == 0 {
        return -1
    }
    
    // Get top element and its increment
    idx := len(this.stack) - 1
    val := this.stack[idx]
    inc := this.increments[idx]
    
    // Remove from stack
    this.stack = this.stack[:idx]
    this.increments = this.increments[:idx]
    
    // Propagate increment to next element if exists
    if len(this.increments) > 0 {
        this.increments[len(this.increments)-1] += inc
    }
    
    return val + inc
}

func (this *CustomStack) Increment(k int, val int)  {
    if len(this.stack) == 0 {
        return
    }
    
    // Find the index to apply increment (k-th from bottom, or bottom element)
    idx := min(k, len(this.stack)) - 1
    this.increments[idx] += val
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Link

[LeetCode 1381 Design a Stack With Increment Operation](https://leetcode.com/problems/design-a-stack-with-increment-operation/)