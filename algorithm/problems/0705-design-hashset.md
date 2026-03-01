# 0705 Design HashSet

## Problem Description

Design a HashSet without using any built-in hash table libraries.

Implement `MyHashSet` class:

- `void add(int key)` Inserts the value `key` into the HashSet.
- `bool contains(int key)` Returns whether the value `key` exists in the HashSet or not.
- `void remove(int key)` Removes the value `key` in the HashSet. If `key` does not exist in the HashSet, do nothing.

### Example 1:
```
Input
["MyHashSet", "add", "add", "contains", "contains", "add", "contains", "remove", "contains"]
[[], [1], [2], [1], [3], [2], [2], [2], [2]]
Output
[null, null, null, true, false, null, true, null, false]

Explanation
MyHashSet myHashSet = new MyHashSet();
myHashSet.add(1);      // set = [1]
myHashSet.add(2);      // set = [1, 2]
myHashSet.contains(1); // return True
myHashSet.contains(3); // return False, (not found)
myHashSet.add(2);      // set = [1, 2]
myHashSet.contains(2); // return True
myHashSet.remove(2);   // set = [1]
myHashSet.contains(2); // return False, (already removed)
```

## The Twist

Implementing a hash set from scratch without using built-in hash table libraries. The challenge is to handle collisions efficiently.

## Algorithm

### Separate Chaining with Linked Lists Approach:
1. Use an array of linked lists as buckets
2. For each key, compute hash = key % bucketSize
3. Use linked list at that bucket to handle collisions
4. For add(key):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - If not found, add it to the linked list
5. For contains(key):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - Return true if found, false otherwise
6. For remove(key):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - If found, remove it from the linked list

The key insight is using separate chaining with linked lists to handle collisions efficiently.

## Complexity

- **Time**: 
  - add: O(1) average case, O(n) worst case (all keys in same bucket)
  - contains: O(1) average case, O(n) worst case
  - remove: O(1) average case, O(n) worst case
- **Space**: O(n) where n is the number of elements

## Solution Code

```go
package main

type ListNode struct {
    key  int
    next *ListNode
}

type MyHashSet struct {
    buckets []*ListNode
    size    int
}

func Constructor() MyHashSet {
    size := 1000
    buckets := make([]*ListNode, size)
    return MyHashSet{
        buckets: buckets,
        size:    size,
    }
}

func (this *MyHashSet) hash(key int) int {
    return key % this.size
}

func (this *MyHashSet) Add(key int)  {
    hash := this.hash(key)
    bucket := this.buckets[hash]
    
    // Check if key already exists
    current := bucket
    for current != nil {
        if current.key == key {
            return // Key already exists
        }
        current = current.next
    }
    
    // Add new key at the beginning of the list
    newNode := &ListNode{key: key, next: bucket}
    this.buckets[hash] = newNode
}

func (this *MyHashSet) Remove(key int)  {
    hash := this.hash(key)
    bucket := this.buckets[hash]
    
    if bucket == nil {
        return
    }
    
    // If key is at the head
    if bucket.key == key {
        this.buckets[hash] = bucket.next
        return
    }
    
    // Search for key in the rest of the list
    prev := bucket
    current := bucket.next
    for current != nil {
        if current.key == key {
            prev.next = current.next
            return
        }
        prev = current
        current = current.next
    }
}

func (this *MyHashSet) Contains(key int) bool {
    hash := this.hash(key)
    current := this.buckets[hash]
    
    for current != nil {
        if current.key == key {
            return true
        }
        current = current.next
    }
    
    return false
}
```

## Link

[LeetCode 0705 Design HashSet](https://leetcode.com/problems/design-hashset/)