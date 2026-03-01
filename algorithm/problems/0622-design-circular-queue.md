# 0622 Design Circular Queue

## Problem Description

Design your implementation of the circular queue. The circular queue is a linear data structure in which the operations are performed based on FIFO (First In First Out) principle and the last position is connected back to the first position to make a circle. It is also called "Ring Buffer".

One of the benefits of the circular queue is that we can utilize the spaces in front of the queue. In a normal queue, once the queue becomes full, we cannot insert the next element even if there is a space in front of the queue. But using the circular queue, we can use the space to store new values.

Implement the `MyCircularQueue` class:

- `MyCircularQueue(int k)` Initializes the object with the size of the queue to be `k`.
- `bool enQueue(int value)` Inserts an element into the circular queue. Returns true if the operation is successful.
- `bool deQueue()` Deletes an element from the circular queue. Returns true if the operation is successful.
- `int Front()` Gets the front item from the queue. If the queue is empty, return -1.
- `int Rear()` Gets the last item from the queue. If the queue is empty, return -1.
- `bool isEmpty()` Checks whether the circular queue is empty or not.
- `bool isFull()` Checks whether the circular queue is full or not.

### Example 1:
```
Input
["MyCircularQueue", "enQueue", "enQueue", "enQueue", "enQueue", "Rear", "isFull", "deQueue", "enQueue", "Rear"]
[[3], [1], [2], [3], [4], [], [], [], [4], []]
Output
[null, true, true, true, false, 3, true, true, true, 4]

Explanation
MyCircularQueue myCircularQueue = new MyCircularQueue(3);
myCircularQueue.enQueue(1); // return True
myCircularQueue.enQueue(2); // return True
myCircularQueue.enQueue(3); // return True
myCircularQueue.enQueue(4); // return False
myCircularQueue.Rear();     // return 3
myCircularQueue.isFull();   // return True
myCircularQueue.deQueue();  // return True
myCircularQueue.enQueue(4); // return True
myCircularQueue.Rear();     // return 4
```

## The Twist

Implementing a circular queue that efficiently utilizes all available space by connecting the end back to the beginning.

## Algorithm

### Array with Two Pointers Approach:
1. Use an array of size k to store elements
2. Use two pointers: `head` and `tail` to track front and rear positions
3. Use a `count` variable to track current number of elements
4. For enQueue(value):
   - If queue is full, return false
   - Add value at tail position
   - Move tail to next position (using modulo for circular behavior)
   - Increment count
5. For deQueue():
   - If queue is empty, return false
   - Move head to next position (using modulo for circular behavior)
   - Decrement count
6. For Front(): return element at head position or -1 if empty
7. For Rear(): return element at (tail-1) position or -1 if empty
8. For isEmpty(): check if count is 0
9. For isFull(): check if count equals capacity

The key insight is using modulo arithmetic to handle the circular nature: `next = (current + 1) % capacity`

## Complexity

- **Time**: O(1) for all operations
- **Space**: O(k) where k is the capacity of the queue

## Solution Code

```go
package main

type MyCircularQueue struct {
    data   []int
    head   int
    tail   int
    size   int
    capacity int
}

func Constructor(k int) MyCircularQueue {
    return MyCircularQueue{
        data:     make([]int, k),
        head:     0,
        tail:     0,
        size:     0,
        capacity: k,
    }
}

func (this *MyCircularQueue) EnQueue(value int) bool {
    if this.IsFull() {
        return false
    }
    
    this.data[this.tail] = value
    this.tail = (this.tail + 1) % this.capacity
    this.size++
    return true
}

func (this *MyCircularQueue) DeQueue() bool {
    if this.IsEmpty() {
        return false
    }
    
    this.head = (this.head + 1) % this.capacity
    this.size--
    return true
}

func (this *MyCircularQueue) Front() int {
    if this.IsEmpty() {
        return -1
    }
    return this.data[this.head]
}

func (this *MyCircularQueue) Rear() int {
    if this.IsEmpty() {
        return -1
    }
    // tail points to the next insertion position, so rear is at tail-1
    rearIndex := (this.tail - 1 + this.capacity) % this.capacity
    return this.data[rearIndex]
}

func (this *MyCircularQueue) IsEmpty() bool {
    return this.size == 0
}

func (this *MyCircularQueue) IsFull() bool {
    return this.size == this.capacity
}
```

## Link

[LeetCode 0622 Design Circular Queue](https://leetcode.com/problems/design-circular-queue/)