# 0146 LRU Cache

## Problem Description

Design a data structure that follows the constraints of a Least Recently Used (LRU) cache.

Implement the `LRUCache` class:

- `LRUCache(int capacity)` Initialize the LRU cache with positive size capacity.
- `int get(int key)` Return the value of the key if the key exists, otherwise return -1.
- `void put(int key, int value)` Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the capacity from this operation, evict the least recently used key.

The functions `get` and `put` must each run in O(1) average time complexity.

### Example 1:
```
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]

Explanation
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // cache is {1=1}
lRUCache.put(2, 2); // cache is {1=1, 2=2}
lRUCache.get(1);    // return 1
lRUCache.put(3, 3); // LRU key was 2, evicts key 2, cache is {1=1, 3=3}
lRUCache.get(2);    // returns -1 (not found)
lRUCache.put(4, 4); // LRU key was 1, evicts key 1, cache is {3=3, 4=4}
lRUCache.get(1);    // return -1 (not found)
lRUCache.get(3);    // return 3
lRUCache.get(4);    // return 4
```

## The Twist

Implementing an LRU cache with O(1) time complexity for both get and put operations. This requires using a combination of a hash map for O(1) access and a doubly linked list to maintain the order of usage.

## Algorithm

### Hash Map + Doubly Linked List:
1. Use a hash map to store key-node pairs for O(1) access
2. Use a doubly linked list to maintain the order of usage
3. When accessing a key (get), move the corresponding node to the front of the list
4. When adding a key (put):
   - If key exists, update its value and move it to the front
   - If key doesn't exist:
     - If cache is full, remove the least recently used node (tail)
     - Add the new key-value pair to the front of the list
5. The most recently used items are at the front, least recently used at the back

## Complexity

- **Time**: O(1) for both get and put operations
- **Space**: O(capacity) - storing at most capacity key-value pairs

## Solution Code

```go
package main

type Node struct {
    key   int
    value int
    prev  *Node
    next  *Node
}

type LRUCache struct {
    capacity int
    cache    map[int]*Node
    head     *Node
    tail     *Node
}

func Constructor(capacity int) LRUCache {
    head := &Node{}
    tail := &Node{}
    head.next = tail
    tail.prev = head
    
    return LRUCache{
        capacity: capacity,
        cache:    make(map[int]*Node),
        head:     head,
        tail:     tail,
    }
}

func (this *LRUCache) Get(key int) int {
    if node, ok := this.cache[key]; ok {
        this.moveToFront(node)
        return node.value
    }
    return -1
}

func (this *LRUCache) Put(key int, value int) {
    if node, ok := this.cache[key]; ok {
        node.value = value
        this.moveToFront(node)
        return
    }
    
    if len(this.cache) >= this.capacity {
        this.removeLast()
    }
    
    newNode := &Node{key: key, value: value}
    this.addToFront(newNode)
    this.cache[key] = newNode
}

func (this *LRUCache) moveToFront(node *Node) {
    this.remove(node)
    this.addToFront(node)
}

func (this *LRUCache) addToFront(node *Node) {
    node.prev = this.head
    node.next = this.head.next
    this.head.next.prev = node
    this.head.next = node
}

func (this *LRUCache) remove(node *Node) {
    node.prev.next = node.next
    node.next.prev = node.prev
}

func (this *LRUCache) removeLast() {
    last := this.tail.prev
    this.remove(last)
    delete(this.cache, last.key)
}
```

## Link

[LeetCode 0146 LRU Cache](https://leetcode.com/problems/lru-cache/)