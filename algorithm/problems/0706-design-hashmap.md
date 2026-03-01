# 0706 Design HashMap

## Problem Description

Design a HashMap without using any built-in hash table libraries.

Implement the `MyHashMap` class:

- `MyHashMap()` Initializes the object with an empty map.
- `void put(int key, int value)` Inserts a `(key, value)` pair into the HashMap. If the `key` already exists in the map, update the corresponding `value`.
- `int get(int key)` Returns the value to which the specified `key` is mapped, or `-1` if this map contains no mapping for the `key`.
- `void remove(int key)` Remove the mapping for the value `key` if this map contains the mapping for the `key`.

### Example 1:
```
Input
["MyHashMap", "put", "put", "get", "get", "put", "get", "remove", "get"]
[[], [1, 1], [2, 2], [1], [3], [2, 1], [2], [2], [2]]
Output
[null, null, null, 1, -1, null, 1, null, -1]

Explanation
MyHashMap myHashMap = new MyHashMap();
myHashMap.put(1, 1); // The map is now [[1,1]]
myHashMap.put(2, 2); // The map is now [[1,1], [2,2]]
myHashMap.get(1);    // return 1, The map is now [[1,1], [2,2]]
myHashMap.get(3);    // return -1 (i.e., not found), The map is now [[1,1], [2,2]]
myHashMap.put(2, 1); // The map is now [[1,1], [2,1]] (i.e., update the existing value)
myHashMap.get(2);    // return 1, The map is now [[1,1], [2,1]]
myHashMap.remove(2); // remove the mapping for 2, The map is now [[1,1]]
myHashMap.get(2);    // return -1 (i.e., not found), The map is now [[1,1]]
```

## The Twist

Implementing a hash map from scratch without using built-in hash table libraries. The challenge is to handle key-value pairs and collisions efficiently.

## Algorithm

### Separate Chaining with Linked Lists Approach:
1. Use an array of linked lists as buckets
2. For each key, compute hash = key % bucketSize
3. Use linked list at that bucket to handle collisions
4. For put(key, value):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - If found, update the value
   - If not found, add new key-value pair to the linked list
5. For get(key):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - Return value if found, -1 otherwise
6. For remove(key):
   - Compute hash and find the corresponding bucket
   - Search the linked list for the key
   - If found, remove it from the linked list

The key insight is using separate chaining with linked lists to handle collisions efficiently for key-value pairs.

## Complexity

- **Time**: 
  - put: O(1) average case, O(n) worst case (all keys in same bucket)
  - get: O(1) average case, O(n) worst case
  - remove: O(1) average case, O(n) worst case
- **Space**: O(n) where n is the number of key-value pairs

## Solution Code

```go
package main

type Pair struct {
    key   int
    value int
    next  *Pair
}

type MyHashMap struct {
    buckets []*Pair
    size    int
}

func Constructor() MyHashMap {
    size := 1000
    buckets := make([]*Pair, size)
    return MyHashMap{
        buckets: buckets,
        size:    size,
    }
}

func (this *MyHashMap) hash(key int) int {
    return key % this.size
}

func (this *MyHashMap) Put(key int, value int)  {
    hash := this.hash(key)
    current := this.buckets[hash]
    
    // Check if key already exists
    for current != nil {
        if current.key == key {
            current.value = value // Update existing key
            return
        }
        current = current.next
    }
    
    // Add new key-value pair at the beginning of the list
    newPair := &Pair{key: key, value: value, next: this.buckets[hash]}
    this.buckets[hash] = newPair
}

func (this *MyHashMap) Get(key int) int {
    hash := this.hash(key)
    current := this.buckets[hash]
    
    for current != nil {
        if current.key == key {
            return current.value
        }
        current = current.next
    }
    
    return -1
}

func (this *MyHashMap) Remove(key int)  {
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
```

## Link

[LeetCode 0706 Design HashMap](https://leetcode.com/problems/design-hashmap/)