# 0641 Design Circular Deque

## Problem Description

Design your implementation of the circular double-ended queue (deque).

Implement the `MyCircularDeque` class:

- `MyCircularDeque(int k)` Initializes the deque with a maximum size of `k`.
- `bool insertFront()` Adds an item at the front of Deque. Returns true if the operation is successful.
- `bool insertLast()` Adds an item at the rear of Deque. Returns true if the operation is successful.
- `bool deleteFront()` Deletes an item from the front of Deque. Returns true if the operation is successful.
- `bool deleteLast()` Deletes an item from the rear of Deque. Returns true if the operation is successful.
- `int getFront()` Returns the front item from the Deque. If the deque is empty, return -1.
- `int getRear()` Returns the last item from Deque. If the deque is empty, return -1.
- `bool isEmpty()` Returns true if the deque is empty, or false otherwise.
- `bool isFull()` Returns true if the deque is full, or false otherwise.

### Example 1:
```
Input
["MyCircularDeque", "insertLast", "insertLast", "insertFront", "insertFront", "getRear", "isFull", "deleteLast", "insertFront", "getFront"]
[[3], [1], [2], [3], [4], [], [], [], [4], []]
Output
[null, true, true, true, false, 2, true, true, true, 4]

Explanation
MyCircularDeque myCircularDeque = new MyCircularDeque(3);
myCircularDeque.insertLast(1);  // return True
myCircularDeque.insertLast(2);  // return True
myCircularDeque.insertFront(3); // return True
myCircularDeque.insertFront(4); // return False, the queue is full.
myCircularDeque.getRear();      // return 2
myCircularDeque.isFull();       // return True
myCircularDeque.deleteLast();   // return True
myCircularDeque.insertFront(4); // return True
myCircularDeque.getFront();     // return 4
```

## The Twist

Implementing a circular double-ended queue that supports efficient insertion and deletion at both ends.

## Algorithm

### Array with Two Pointers Approach:
1. Use an array of size k to store elements
2. Use two pointers: `head` and `tail` to track front and rear positions
3. Use a `size` variable to track current number of elements
4. For insertFront(value):
   - If deque is full, return false
   - Move head backward (using modulo for circular behavior)
   - Add value at new head position
   - Increment size
5. For insertLast(value):
   - If deque is full, return false
   - Add value at tail position
   - Move tail forward (using modulo for circular behavior)
   - Increment size
6. For deleteFront():
   - If deque is empty, return false
   - Move head forward (using modulo for circular behavior)
   - Decrement size
7. For deleteLast():
   - If deque is empty, return false
   - Move tail backward (using modulo for circular behavior)
   - Decrement size
8. For getFront(): return element at head position or -1 if empty
9. For getRear(): return element at (tail-1) position or -1 if empty
10. For isEmpty(): check if size is 0
11. For isFull(): check if size equals capacity

The key insight is using modulo arithmetic to handle the circular nature: `next = (current + 1) % capacity` and `prev = (current - 1 + capacity) % capacity`

## Complexity

- **Time**: O(1) for all operations
- **Space**: O(k) where k is the capacity of the deque

## Solution Code

```go
package main

type MyCircularDeque struct {
    data     []int
    head     int
    tail     int
    size     int
    capacity int
}

func Constructor(k int) MyCircularDeque {
    return MyCircularDeque{
        data:     make([]int, k),
        head:     0,
        tail:     0,
        size:     0,
        capacity: k,
    }
}

func (this *MyCircularDeque) InsertFront(value int) bool {
    if this.IsFull() {
        return false
    }
    
    // Move head backward
    this.head = (this.head - 1 + this.capacity) % this.capacity
    this.data[this.head] = value
    this.size++
    return true
}

func (this *MyCircularDeque) InsertLast(value int) bool {
    if this.IsFull() {
        return false
    }
    
    // Add value at tail position
    this.data[this.tail] = value
    // Move tail forward
    this.tail = (this.tail + 1) % this.capacity
    this.size++
    return true
}

func (this *MyCircularDeque) DeleteFront() bool {
    if this.IsEmpty() {
        return false
    }
    
    // Move head forward
    this.head = (this.head + 1) % this.capacity
    this.size--
    return true
}

func (this *MyCircularDeque) DeleteLast() bool {
    if this.IsEmpty() {
        return false
    }
    
    // Move tail backward
    this.tail = (this.tail - 1 + this.capacity) % this.capacity
    this.size--
    return true
}

func (this *MyCircularDeque) GetFront() int {
    if this.IsEmpty() {
        return -1
    }
    return this.data[this.head]
}

func (this *MyCircularDeque) GetRear() int {
    if this.IsEmpty() {
        return -1
    }
    // tail points to the next insertion position, so rear is at tail-1
    rearIndex := (this.tail - 1 + this.capacity) % this.capacity
    return this.data[rearIndex]
}

func (this *MyCircularDeque) IsEmpty() bool {
    return this.size == 0
}

func (this *MyCircularDeque) IsFull() bool {
    return this.size == this.capacity
}
```

## Link

[LeetCode 0641 Design Circular Deque](https://leetcode.com/problems/design-circular-deque/)