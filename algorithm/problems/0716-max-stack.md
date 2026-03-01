# 0716 Max Stack

## Problem Description

Design a max stack data structure that supports the stack operations and supports finding the maximum element in the stack.

Implement the `MaxStack` class:

- `MaxStack()` Initializes the object.
- `void push(int x)` Pushes element x onto the stack.
- `int pop()` Removes the element on top of the stack and returns it.
- `int top()` Gets the element on the top of the stack.
- `int peekMax()` Retrieves the maximum element in the stack without removing it.
- `int popMax()` Retrieves the maximum element in the stack and removes it. If there are more than one maximum elements, only remove the top-most one.

### Example 1:
```
Input
["MaxStack", "push", "push", "push", "top", "popMax", "top", "peekMax", "pop", "top"]
[[], [5], [1], [5], [], [], [], [], [], []]
Output
[null, null, null, null, 5, 5, 1, 5, 1, 5]

Explanation
MaxStack stk = new MaxStack();
stk.push(5);   // [5] the top of the stack and the maximum number is 5.
stk.push(1);   // [5, 1] the top of the stack is 1, but the maximum is 5.
stk.push(5);   // [5, 1, 5] the top of the stack is 5, which is also the maximum, because it is the topmost one.
stk.top();     // return 5
stk.popMax();  // return 5, [5, 1] the stack is changed now, and the top is different from the max.
stk.top();     // return 1
stk.peekMax(); // return 5
stk.pop();     // return 1, [5] the top of the stack and the max is now 5.
stk.top();     // return 5
```

## The Twist

Implementing a stack that can efficiently find and remove the maximum element while maintaining stack order.

## Algorithm

### Double Linked List + TreeMap Approach:
1. Use a doubly linked list to maintain stack order for O(1) push/pop/top operations
2. Use a TreeMap (or map of values to sets of nodes) to track maximum values and their positions
3. For push(x):
   - Create a new node with value x
   - Add it to the front of the doubly linked list
   - Add the node to the TreeMap under key x
4. For pop():
   - Remove the front node from the doubly linked list
   - Remove the node from the TreeMap
   - Return the node's value
5. For top():
   - Return the value of the front node
6. For peekMax():
   - Return the maximum key from the TreeMap
7. For popMax():
   - Get the maximum value from TreeMap
   - Get one of the nodes with this value
   - Remove the node from both the doubly linked list and TreeMap
   - Return the value

The key insight is maintaining two data structures: one for stack order and one for efficient maximum lookup.

## Complexity

- **Time**: 
  - push: O(logn) - due to TreeMap insertion
  - pop: O(logn) - due to TreeMap removal
  - top: O(1)
  - peekMax: O(1)
  - popMax: O(logn) - due to TreeMap operations
- **Space**: O(n) - storing all elements in both data structures

## Solution Code

```go
package main

import "container/list"

type Node struct {
    element *list.Element
    value   int
}

type MaxStack struct {
    stack    *list.List
    maxMap   map[int][]*Node
    maxValue int
}

func Constructor() MaxStack {
    return MaxStack{
        stack:  list.New(),
        maxMap: make(map[int][]*Node),
    }
}

func (this *MaxStack) Push(x int) {
    // Add to stack
    element := this.stack.PushFront(x)
    
    // Create node and add to maxMap
    node := &Node{
        element: element,
        value:   x,
    }
    
    this.maxMap[x] = append(this.maxMap[x], node)
    
    // Update maxValue if needed
    if x > this.maxValue {
        this.maxValue = x
    }
}

func (this *MaxStack) Pop() int {
    if this.stack.Len() == 0 {
        return -1
    }
    
    element := this.stack.Front()
    value := element.Value.(int)
    
    // Remove from stack
    this.stack.Remove(element)
    
    // Remove from maxMap
    nodes := this.maxMap[value]
    if len(nodes) > 0 {
        // Remove the last node (which should be this one)
        this.maxMap[value] = nodes[:len(nodes)-1]
        if len(this.maxMap[value]) == 0 {
            delete(this.maxMap, value)
            
            // Update maxValue if needed
            if value == this.maxValue {
                this.maxValue = this.findNewMax()
            }
        }
    }
    
    return value
}

func (this *MaxStack) Top() int {
    if this.stack.Len() == 0 {
        return -1
    }
    
    element := this.stack.Front()
    return element.Value.(int)
}

func (this *MaxStack) PeekMax() int {
    if len(this.maxMap) == 0 {
        return -1
    }
    
    return this.maxValue
}

func (this *MaxStack) PopMax() int {
    if len(this.maxMap) == 0 {
        return -1
    }
    
    // Get the max value
    maxValue := this.maxValue
    
    // Get the last node with this value (topmost in stack)
    nodes := this.maxMap[maxValue]
    node := nodes[len(nodes)-1]
    
    // Remove from maxMap
    this.maxMap[maxValue] = nodes[:len(nodes)-1]
    if len(this.maxMap[maxValue]) == 0 {
        delete(this.maxMap, maxValue)
    }
    
    // Remove from stack
    this.stack.Remove(node.element)
    
    // Update maxValue if needed
    if len(this.maxMap[maxValue]) == 0 {
        this.maxValue = this.findNewMax()
    }
    
    return maxValue
}

func (this *MaxStack) findNewMax() int {
    newMax := 0
    for value := range this.maxMap {
        if value > newMax {
            newMax = value
        }
    }
    return newMax
}
```

## Link

[LeetCode 0716 Max Stack](https://leetcode.com/problems/max-stack/)