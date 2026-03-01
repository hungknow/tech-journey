# 0707 Design Linked List

## Problem Description

Design your implementation of the linked list. You can choose to use a singly or doubly linked list.
A node in a singly linked list should have two attributes: `val` and `next`. `val` is the value of the current node, and `next` is a pointer/reference to the next node.
If you want to use the doubly linked list, you will need one more attribute `prev` to indicate the previous node in the linked list. Assume all nodes in the linked list are 0-indexed.

Implement the `MyLinkedList` class:

- `MyLinkedList()` Initializes the `MyLinkedList` object.
- `int get(int index)` Get the value of the `index`th node in the linked list. If the index is invalid, return `-1`.
- `void addAtHead(int val)` Add a node of value `val` before the first element of the linked list. After the insertion, the new node will be the first node of the linked list.
- `void addAtTail(int val)` Append a node of value `val` as the last element of the linked list.
- `void addAtIndex(int index, int val)` Add a node of value `val` before the `index`th node in the linked list. If `index` equals the length of the linked list, the node will be appended to the end of the linked list. If `index` is greater than the length, the node will not be inserted.
- `void deleteAtIndex(int index)` Delete the `index`th node in the linked list, if the index is valid.

### Example 1:
```
Input
["MyLinkedList", "addAtHead", "addAtTail", "addAtIndex", "get", "deleteAtIndex", "get"]
[[], [1], [3], [1, 2], [1], [1], [1]]
Output
[null, null, null, null, 2, null, 3]

Explanation
MyLinkedList myLinkedList = new MyLinkedList();
myLinkedList.addAtHead(1);
myLinkedList.addAtTail(3);
myLinkedList.addAtIndex(1, 2);    // linked list becomes 1->2->3
myLinkedList.get(1);              // return 2
myLinkedList.deleteAtIndex(1);    // now the linked list is 1->3
myLinkedList.get(1);              // return 3
```

## The Twist

Implementing a linked list from scratch with proper handling of edge cases like empty list, head/tail operations, and index bounds checking.

## Algorithm

### Doubly Linked List Approach:
1. Define a Node class with val, next, and prev pointers
2. Initialize the linked list with a dummy head node to simplify edge cases
3. For get(index):
   - Traverse from head to the index-th node
   - Return the node's value or -1 if index is invalid
4. For addAtHead(val):
   - Create a new node with the given value
   - Insert it after the dummy head node
   - Update next and prev pointers accordingly
5. For addAtTail(val):
   - Traverse to the last node
   - Create a new node and append it
   - Update next and prev pointers
6. For addAtIndex(index, val):
   - Traverse to the node at index-1
   - Insert the new node between the current node and its next
   - Update all relevant pointers
7. For deleteAtIndex(index):
   - Traverse to the node at index-1
   - Remove the next node by updating pointers
   - Handle edge cases

The key insight is using a dummy head node to simplify edge cases and maintaining both next and prev pointers for efficient operations.

## Complexity

- **Time**: 
  - get: O(n) where n is the length of the linked list
  - addAtHead: O(1)
  - addAtTail: O(n)
  - addAtIndex: O(n)
  - deleteAtIndex: O(n)
- **Space**: O(n) where n is the number of nodes in the linked list

## Solution Code

```go
package main

type Node struct {
	val  int
	next *Node
	prev *Node
}

type MyLinkedList struct {
	head *Node
	size int
}

func Constructor() MyLinkedList {
	// Initialize with a dummy head node
	dummyHead := &Node{val: 0}
	return MyLinkedList{
		head: dummyHead,
		size: 0,
	}
}

func (this *MyLinkedList) Get(index int) int {
	if index < 0 || index >= this.size {
		return -1
	}
	
	current := this.head.next
	for i := 0; i < index; i++ {
		current = current.next
	}
	
	return current.val
}

func (this *MyLinkedList) AddAtHead(val int) {
	this.AddAtIndex(0, val)
}

func (this *MyLinkedList) AddAtTail(val int) {
	this.AddAtIndex(this.size, val)
}

func (this *MyLinkedList) AddAtIndex(index int, val int) {
	if index < 0 || index > this.size {
		return
	}
	
	// Find the node at index-1 (or dummy head if index is 0)
	prev := this.head
	for i := 0; i < index; i++ {
		prev = prev.next
	}
	
	// Create new node
	newNode := &Node{
		val:  val,
		next: prev.next,
		prev: prev,
	}
	
	// Update pointers
	if prev.next != nil {
		prev.next.prev = newNode
	}
	prev.next = newNode
	
	this.size++
}

func (this *MyLinkedList) DeleteAtIndex(index int) {
	if index < 0 || index >= this.size {
		return
	}
	
	// Find the node at index-1
	prev := this.head
	for i := 0; i < index; i++ {
		prev = prev.next
	}
	
	// Remove the node
	toDelete := prev.next
	prev.next = toDelete.next
	
	if toDelete.next != nil {
		toDelete.next.prev = prev
	}
	
	this.size--
}

/**
 * Your MyLinkedList object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Get(index);
 * obj.AddAtHead(val);
 * obj.AddAtTail(val);
 * obj.AddAtIndex(index,val);
 * obj.DeleteAtIndex(index);
 */
```

## Link

[LeetCode 0707 Design Linked List](https://leetcode.com/problems/design-linked-list/)