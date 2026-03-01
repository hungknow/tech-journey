# 0432 All O`one Data Structure

## Problem Description

Design a data structure to store the strings' count with the ability to return the strings with minimum and maximum counts.

Implement the `AllOne` class:

- `AllOne()` Initializes the object of the data structure.
- `void inc(String key)` Increments the count of the string `key` by 1. If `key` does not exist in the data structure, insert it with count 1.
- `void dec(String key)` Decrements the count of the string `key` by 1. If `key` does not exist in the data structure, do nothing. If the count of `key` becomes 0 after the decrement, remove it from the data structure.
- `String getMaxKey()` Returns one of the keys with the maximum count. If no element exists, return an empty string `""`.
- `String getMinKey()` Returns one of the keys with the minimum count. If no element exists, return an empty string `""`.

### Example 1:
```
Input
["AllOne", "inc", "inc", "getMaxKey", "getMinKey", "inc", "getMaxKey", "getMinKey"]
[[], ["hello"], ["hello"], [], [], ["leet"], [], []]
Output
[null, null, null, "hello", "hello", null, "hello", "leet"]

Explanation
AllOne allOne = new AllOne();
allOne.inc("hello");
allOne.inc("hello");
allOne.getMaxKey(); // return "hello"
allOne.getMinKey(); // return "hello"
allOne.inc("leet");
allOne.getMaxKey(); // return "hello"
allOne.getMinKey(); // return "leet"
```

## The Twist

Implementing a data structure that supports increment, decrement, and retrieving the keys with minimum and maximum counts all in O(1) time complexity.

## Algorithm

### Doubly Linked List + HashMap Approach:
1. Use a doubly linked list where each node represents a count and contains a set of keys with that count
2. Use a HashMap to map each key to its corresponding node in the linked list
3. Maintain the linked list in ascending order of counts
4. For inc(key):
   - If key doesn't exist, add it to the node with count 1 (create if needed)
   - If key exists, move it to the next node with count+1 (create if needed)
   - If the original node becomes empty, remove it
5. For dec(key):
   - If key doesn't exist, do nothing
   - If key exists and count > 1, move it to the previous node with count-1 (create if needed)
   - If key exists and count = 1, remove it completely
   - If the original node becomes empty, remove it
6. For getMaxKey():
   - Return any key from the last node in the linked list
7. For getMinKey():
   - Return any key from the first node in the linked list

The key insight is using a doubly linked list to maintain keys sorted by their counts, allowing O(1) access to min and max.

## Complexity

- **Time**: 
  - inc: O(1) average
  - dec: O(1) average
  - getMaxKey: O(1)
  - getMinKey: O(1)
- **Space**: O(n) where n is the number of unique keys

## Solution Code

```go
package main

type AllOne struct {
	keyCount map[string]int
	countKeys map[int]map[string]struct{}
	head, tail *CountNode
}

type CountNode struct {
	count int
	keys map[string]struct{}
	prev, next *CountNode
}

func Constructor() AllOne {
	head := &CountNode{count: 0}
	tail := &CountNode{count: 0}
	head.next = tail
	tail.prev = head
	
	return AllOne{
		keyCount:  make(map[string]int),
		countKeys: make(map[int]map[string]struct{}),
		head:      head,
		tail:      tail,
	}
}

func (this *AllOne) Inc(key string) {
	if count, exists := this.keyCount[key]; exists {
		this.removeKeyFromCount(key, count)
		this.addKeyToCount(key, count+1)
	} else {
		this.addKeyToCount(key, 1)
	}
}

func (this *AllOne) Dec(key string) {
	if count, exists := this.keyCount[key]; exists {
		this.removeKeyFromCount(key, count)
		if count > 1 {
			this.addKeyToCount(key, count-1)
		} else {
			delete(this.keyCount, key)
		}
	}
}

func (this *AllOne) GetMaxKey() string {
	if this.tail.prev == this.head {
		return ""
	}
	
	for key := range this.tail.prev.keys {
		return key
	}
	return ""
}

func (this *AllOne) GetMinKey() string {
	if this.head.next == this.tail {
		return ""
	}
	
	for key := range this.head.next.keys {
		return key
	}
	return ""
}

func (this *AllOne) addKeyToCount(key string, count int) {
	this.keyCount[key] = count
	
	if _, exists := this.countKeys[count]; !exists {
		this.countKeys[count] = make(map[string]struct{})
		this.insertCountNode(count)
	}
	
	this.countKeys[count][key] = struct{}{}
}

func (this *AllOne) removeKeyFromCount(key string, count int) {
	delete(this.countKeys[count], key)
	if len(this.countKeys[count]) == 0 {
		delete(this.countKeys, count)
		this.removeCountNode(count)
	}
}

func (this *AllOne) insertCountNode(count int) {
	newNode := &CountNode{
		count: count,
		keys:  this.countKeys[count],
	}
	
	curr := this.head
	for curr.next != this.tail && curr.next.count < count {
		curr = curr.next
	}
	
	newNode.prev = curr
	newNode.next = curr.next
	curr.next.prev = newNode
	curr.next = newNode
}

func (this *AllOne) removeCountNode(count int) {
	curr := this.head.next
	for curr != this.tail && curr.count != count {
		curr = curr.next
	}
	
	if curr != this.tail {
		curr.prev.next = curr.next
		curr.next.prev = curr.prev
	}
}
```

## Link

[LeetCode 0432 All O`one Data Structure](https://leetcode.com/problems/all-oone-data-structure/)