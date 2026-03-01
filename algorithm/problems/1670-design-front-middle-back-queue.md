# 1670 Design Front Middle Back Queue

## Problem Description

Design a queue that supports `push` and `pop` operations on the front, middle, and back of the queue.

Implement the `FrontMiddleBackQueue` class:

- `FrontMiddleBackQueue()` Initializes the queue.
- `void pushFront(int val)` Adds `val` to the front of the queue.
- `void pushMiddle(int val)` Adds `val` to the middle of the queue.
- `void pushBack(int val)` Adds `val` to the back of the queue.
- `int popFront()` Removes the front element of the queue and returns it. If the queue is empty, return -1.
- `int popMiddle()` Removes the middle element of the queue and returns it. If the queue is empty, return -1.
- `int popBack()` Removes the back element of the queue and returns it. If the queue is empty, return -1.

### Example 1:
```
Input:
["FrontMiddleBackQueue", "pushFront", "pushBack", "pushMiddle", "pushMiddle", "popFront", "popMiddle", "popMiddle", "popBack", "popFront"]
[[], [1], [2], [3], [4], [], [], [], [], []]
Output:
[null, null, null, null, null, 1, 3, 4, 2, -1]

Explanation:
FrontMiddleBackQueue q = new FrontMiddleBackQueue();
q.pushFront(1);   // [1]
q.pushBack(2);    // [1, 2]
q.pushMiddle(3);  // [1, 3, 2]
q.pushMiddle(4);  // [1, 4, 3, 2]
q.popFront();     // return 1 -> [4, 3, 2]
q.popMiddle();    // return 3 -> [4, 2]
q.popMiddle();    // return 4 -> [2]
q.popBack();      // return 2 -> []
q.popFront();     // return -1 -> [] (The queue is empty)
```

## The Twist

Implementing a queue that supports efficient operations at the front, middle, and back positions. The challenge is to handle middle operations efficiently.

## Algorithm

### Deque Approach:
1. Use a deque (double-ended queue) to store elements
2. For pushFront(val):
   - Add val to the front of the deque
3. For pushBack(val):
   - Add val to the back of the deque
4. For pushMiddle(val):
   - Calculate the middle index: size // 2
   - Insert val at the middle position
5. For popFront():
   - Remove and return from front of deque, or -1 if empty
6. For popBack():
   - Remove and return from back of deque, or -1 if empty
7. For popMiddle():
   - If empty, return -1
   - Calculate the middle index: (size-1) // 2 (left middle for even length)
   - Remove and return element at middle index

The key insight is that we can use a deque and handle middle operations by calculating the appropriate index.

## Complexity

- **Time**: 
  - pushFront: O(1)
  - pushBack: O(1)
  - pushMiddle: O(n) - need to shift elements
  - popFront: O(1)
  - popBack: O(1)
  - popMiddle: O(n) - need to shift elements
- **Space**: O(n) - storing all elements in the deque

## Solution Code

```go
package main

type FrontMiddleBackQueue struct {
    data []int
}

func Constructor() FrontMiddleBackQueue {
    return FrontMiddleBackQueue{
        data: make([]int, 0),
    }
}

func (this *FrontMiddleBackQueue) PushFront(val int)  {
    this.data = append([]int{val}, this.data...)
}

func (this *FrontMiddleBackQueue) PushMiddle(val int)  {
    n := len(this.data)
    middle := n / 2
    
    // Create new slice with val inserted at middle
    newData := make([]int, 0, n+1)
    newData = append(newData, this.data[:middle]...)
    newData = append(newData, val)
    newData = append(newData, this.data[middle:]...)
    
    this.data = newData
}

func (this *FrontMiddleBackQueue) PushBack(val int)  {
    this.data = append(this.data, val)
}

func (this *FrontMiddleBackQueue) PopFront() int {
    if len(this.data) == 0 {
        return -1
    }
    
    val := this.data[0]
    this.data = this.data[1:]
    return val
}

func (this *FrontMiddleBackQueue) PopMiddle() int {
    if len(this.data) == 0 {
        return -1
    }
    
    n := len(this.data)
    middle := (n - 1) / 2 // left middle for even length
    
    val := this.data[middle]
    
    // Remove element at middle
    this.data = append(this.data[:middle], this.data[middle+1:]...)
    
    return val
}

func (this *FrontMiddleBackQueue) PopBack() int {
    if len(this.data) == 0 {
        return -1
    }
    
    n := len(this.data)
    val := this.data[n-1]
    this.data = this.data[:n-1]
    return val
}
```

## Link

[LeetCode 1670 Design Front Middle Back Queue](https://leetcode.com/problems/design-front-middle-back-queue/)