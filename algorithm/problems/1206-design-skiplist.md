# 1206 Design Skiplist

## Problem Description

Design a Skiplist without using any built-in data structures.

A Skiplist is a data structure that takes O(log(n)) time to add, erase and search. Comparing with treap and red-black tree which has the same function and performance, the code length of Skiplist can be comparatively short and the idea behind Skiplists are just simple linked lists.

For example, we have a Skiplist containing [30,40,50,60,70,90] and we want to add 80 and 45 into it. The Skiplist works like this:

```
Skiplist
+------------+
|  30        |
+------------+
|  30        |
|  40        |
+------------+
|  30        |
|  40        |
|  50        |
|  60        |
+------------+
|  30        |
|  40        |
|  50        |
|  60        |
|  70        |
|  90        |
+------------+
```

After adding 80 and 45, it should look like this:

```
Skiplist
+------------+
|  30        |
|  40        |
|  50        |
|  60        |
|  70        |
|  80        |
|  90        |
+------------+
|  30        |
|  40        |
|  45        |
|  50        |
|  60        |
|  70        |
|  80        |
|  90        |
+------------+
|  30        |
|  40        |
|  45        |
|  50        |
|  60        |
|  70        |
|  80        |
|  90        |
+------------+
```

Implement the `Skiplist` class:

- `Skiplist()` Initializes the object of the skiplist.
- `bool search(int target)` Returns `true` if the target exists in the skiplist or `false` otherwise.
- `void add(int num)` Inserts the num in the skiplist.
- `bool erase(int num)` Removes the num from the skiplist. Returns `true` if the num existed in the skiplist and `false` otherwise.

## The Twist

Implementing a skiplist data structure from scratch, which provides O(log n) average time complexity for search, insert, and delete operations using multiple layers of linked lists.

## Algorithm

### Multi-level Linked List Approach:
1. Use multiple levels of linked lists, where higher levels have fewer elements
2. Each level is a sorted linked list
3. Each node has pointers to the next node at the same level and to the node below it
4. For search(target):
   - Start from the highest level's head
   - Move forward until the next node's value > target
   - Move down to the next level and repeat
   - If found, return true; otherwise, return false
5. For add(num):
   - Find the insertion position at each level
   - Randomly decide how many levels the new node will appear in
   - Insert the node at each level up to the determined height
6. For erase(num):
   - Find the node at all levels where it appears
   - Remove the node from each level
   - Return true if found, false otherwise

The key insight is using probabilistic leveling to achieve O(log n) average time complexity while maintaining a simple linked list structure.

## Complexity

- **Time**: 
  - search: O(logn) on average
  - add: O(logn) on average
  - erase: O(logn) on average
- **Space**: O(n) where n is the number of elements

## Solution Code

```go
package main

import (
	"math/rand"
	"time"
)

type SkipListNode struct {
	val    int
	right  *SkipListNode
	down   *SkipListNode
}

type Skiplist struct {
	head   *SkipListNode
	levels int
}

func Constructor() Skiplist {
	rand.Seed(time.Now().UnixNano())
	
	// Create dummy head for each level
	head := &SkipListNode{val: -1}
	current := head
	
	// Initialize with 16 levels (adjust as needed)
	for i := 0; i < 16; i++ {
		newHead := &SkipListNode{val: -1}
		current.down = newHead
		current = newHead
	}
	
	return Skiplist{
		head:   head,
		levels: 16,
	}
}

func (this *Skiplist) Search(target int) bool {
	current := this.head
	
	for current != nil {
		// Move right as far as possible
		for current.right != nil && current.right.val < target {
			current = current.right
		}
		
		// Check if we found the target
		if current.right != nil && current.right.val == target {
			return true
		}
		
		// Move down to the next level
		current = current.down
	}
	
	return false
}

func (this *Skiplist) Add(num int) {
	// Find insertion positions at each level
	stack := make([]*SkipListNode, 0)
	current := this.head
	
	for current != nil {
		for current.right != nil && current.right.val < num {
			current = current.right
		}
		stack = append(stack, current)
		current = current.down
	}
	
	// Randomly determine the height of the new node
	height := 1
	for rand.Intn(2) == 1 && height < this.levels {
		height++
	}
	
	// Insert the node at each level up to the determined height
	downNode := &SkipListNode{val: num}
	for i := 0; i < height; i++ {
		level := len(stack) - 1 - i
		if level < 0 {
			// Need to add a new level
			newHead := &SkipListNode{val: -1, down: this.head}
			this.head = newHead
			stack = append([]*SkipListNode{newHead}, stack...)
			level = 0
		}
		
		prev := stack[level]
		newNode := &SkipListNode{
			val:   num,
			right: prev.right,
			down:  downNode,
		}
		prev.right = newNode
		downNode = newNode
	}
}

func (this *Skiplist) Erase(num int) bool {
	found := false
	current := this.head
	
	for current != nil {
		// Move right as far as possible
		for current.right != nil && current.right.val < num {
			current = current.right
		}
		
		// Check if we found the node to erase
		if current.right != nil && current.right.val == num {
			found = true
			// Remove the node
			current.right = current.right.right
		}
		
		// Move down to the next level
		current = current.down
	}
	
	return found
}

/**
 * Your Skiplist object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Search(target);
 * obj.Add(num);
 * param_3 := obj.Erase(num);
 */
```

## Link

[LeetCode 1206 Design Skiplist](https://leetcode.com/problems/design-skiplist/)