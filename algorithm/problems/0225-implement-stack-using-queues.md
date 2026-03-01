# 0225 Implement Stack using Queues

## Problem Description

Implement a last-in-first-out (LIFO) stack using only two queues. The implemented stack should support all the functions of a normal stack (`push`, `top`, `pop`, and `empty`).

Implement the `MyStack` class:

- `void push(int x)` Pushes element x to the top of the stack.
- `int pop()` Removes the element on the top of the stack and returns it.
- `int top()` Returns the element on the top of the stack.
- `boolean empty()` Returns `true` if the stack is empty, `false` otherwise.

### Example 1:
```
Input
["MyStack", "push", "push", "top", "pop", "empty"]
[[], [1], [2], [], [], []]
Output
[null, null, null, 2, 2, false]

Explanation
MyStack myStack = new MyStack();
myStack.push(1);
myStack.push(2);
myStack.top(); // return 2
myStack.pop(); // return 2
myStack.empty(); // return False
```

## The Twist

Implementing a stack using only queues. The key challenge is maintaining LIFO order while only having access to FIFO queue operations.

## Algorithm

### Two Queue Approach:
1. Use two queues: `mainQueue` and `tempQueue`
2. For `push(x)`:
   - Add x to `tempQueue`
   - Move all elements from `mainQueue` to `tempQueue`
   - Swap the queues (now `tempQueue` becomes `mainQueue`)
3. For `pop()`:
   - Remove and return the front element of `mainQueue`
4. For `top()`:
   - Return the front element of `mainQueue` without removing it
5. For `empty()`:
   - Check if `mainQueue` is empty

The key insight is that by always moving existing elements to the temp queue before adding the new element, we ensure the newest element is always at the front of the main queue.

## Complexity

- **Time**: 
  - push: O(n) - need to move all elements
  - pop: O(1) - just remove from front
  - top: O(1) - just peek at front
  - empty: O(1) - check if queue is empty
- **Space**: O(n) - storing all elements in the queues

## Solution Code

```go
package main

import "container/list"

type MyStack struct {
    mainQueue *list.List
    tempQueue *list.List
}

func Constructor() MyStack {
    return MyStack{
        mainQueue: list.New(),
        tempQueue: list.New(),
    }
}

func (this *MyStack) Push(x int) {
    // Add new element to temp queue
    this.tempQueue.PushBack(x)
    
    // Move all elements from main queue to temp queue
    for this.mainQueue.Len() > 0 {
        element := this.mainQueue.Front()
        this.tempQueue.PushBack(element.Value)
        this.mainQueue.Remove(element)
    }
    
    // Swap the queues
    this.mainQueue, this.tempQueue = this.tempQueue, this.mainQueue
}

func (this *MyStack) Pop() int {
    if this.Empty() {
        return -1
    }
    
    element := this.mainQueue.Front()
    value := element.Value.(int)
    this.mainQueue.Remove(element)
    
    return value
}

func (this *MyStack) Top() int {
    if this.Empty() {
        return -1
    }
    
    element := this.mainQueue.Front()
    return element.Value.(int)
}

func (this *MyStack) Empty() bool {
    return this.mainQueue.Len() == 0
}
```

## Link

[LeetCode 0225 Implement Stack using Queues](https://leetcode.com/problems/implement-stack-using-queues/)