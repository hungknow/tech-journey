# 0284 Peeking Iterator

## Problem Description

Design an iterator that supports the `peek` operation on an existing iterator in addition to the standard operations (`hasNext` and `next`).

Implement the `PeekingIterator` class:

- `PeekingIterator(Iterator<int> nums)` Initializes the object with the given integer iterator `iterator`.
- `int peek()` Returns the next element in the iteration without advancing the iterator.
- `int next()` Moves the iterator to the next element and returns it.
- `boolean hasNext()` Returns `true` if there are still elements in the iteration.

### Example 1:
```
Input
["PeekingIterator", "next", "peek", "next", "next", "hasNext"]
[[[1, 2, 3]], [], [], [], [], []]
Output
[null, 1, 2, 2, 3, false]

Explanation
PeekingIterator peekingIterator = new PeekingIterator([1, 2, 3]); // [1,2,3]
peekingIterator.next();    // return 1, the pointer moves to the next element [1,2,3].
peekingIterator.peek();    // return 2, the pointer does not move [1,2,3].
peekingIterator.next();    // return 2, the pointer moves to the next element [1,2,3]
peekingIterator.next();    // return 3, the pointer moves to the next element [1,2,3]
peekingIterator.hasNext(); // return False
```

## The Twist

Implementing an iterator that supports peeking at the next element without advancing the iterator. The challenge is to maintain the state of the underlying iterator while allowing peek operations.

## Algorithm

### Buffer Approach:
1. Use a buffer variable to store the next element when peeked
2. Use a flag to track whether we have a buffered element
3. For initialization:
   - Initialize the underlying iterator
   - Set buffer flag to false
4. For peek():
   - If we don't have a buffered element, get the next element from underlying iterator and store it in buffer
   - Set buffer flag to true
   - Return the buffered element
5. For next():
   - If we have a buffered element:
     - Return the buffered element and clear the buffer
   - Otherwise:
     - Return the next element from underlying iterator
6. For hasNext():
   - If we have a buffered element, return true
   - Otherwise, return hasNext() of underlying iterator

The key insight is to cache the next element when peeked and use it for the next next() call.

## Complexity

- **Time**: 
  - peek: O(1) amortized
  - next: O(1) amortized
  - hasNext: O(1)
- **Space**: O(1) - just storing one buffered element

## Solution Code

```go
package main

type Iterator struct {
    nums []int
    index int
}

func (this *Iterator) hasNext() bool {
    return this.index < len(this.nums)
}

func (this *Iterator) next() int {
    val := this.nums[this.index]
    this.index++
    return val
}

type PeekingIterator struct {
    iterator *Iterator
    peekedValue int
    hasPeeked bool
}

func Constructor(iter *Iterator) *PeekingIterator {
    return &PeekingIterator{
        iterator: iter,
        hasPeeked: false,
    }
}

func (this *PeekingIterator) peek() int {
    if !this.hasPeeked {
        this.peekedValue = this.iterator.next()
        this.hasPeeked = true
    }
    return this.peekedValue
}

func (this *PeekingIterator) next() int {
    if this.hasPeeked {
        this.hasPeeked = false
        return this.peekedValue
    }
    return this.iterator.next()
}

func (this *PeekingIterator) hasNext() bool {
    return this.hasPeeked || this.iterator.hasNext()
}
```

## Link

[LeetCode 0284 Peeking Iterator](https://leetcode.com/problems/peeking-iterator/)