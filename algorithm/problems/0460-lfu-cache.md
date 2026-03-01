# 0460 LFU Cache

## Problem Description

Design and implement a data structure for a Least Frequently Used (LFU) cache.

Implement the `LFUCache` class:

- `LFUCache(int capacity)` Initializes the object with the capacity of the data structure.
- `int get(int key)` Gets the value of the key if the key exists in the cache. Otherwise, returns -1.
- `void put(int key, int value)` Update the value of the key if present, or inserts the key if not already present. When the cache reaches its capacity, it should invalidate and remove the least frequently used key before inserting a new item. For this problem, when there is a tie (i.e., two or more keys with the same frequency), the least recently used key would be invalidated.

To determine the least frequently used key, a use counter is maintained for each key in the cache. The key with the smallest use counter is the least frequently used key.

When a key is first inserted into the cache, its use counter is set to 1 (due to the put operation). The use counter for a key is incremented each time a get or put operation is performed on that key.

The functions `get` and `put` must each run in O(1) average time complexity.

### Example 1:
```
Input
["LFUCache", "put", "put", "get", "put", "get", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [3], [4, 4], [1], [3], [4]]
Output
[null, null, null, 1, null, -1, 3, null, -1, 3, 4]

Explanation
// cnt(x) denotes the count of the number of calls to get(x) and put(x) for a key x
lfu.put(1, 1);   // cnt(1)=1
lfu.put(2, 2);   // cnt(2)=1
lfu.get(1);      // return 1
                 // cnt(1)=2, cnt(2)=1
lfu.put(3, 3);   // 2 is the LFU key because cnt(2)=1 is the smallest count
                 // invalidate 2.
                 // cache is {1=1, 3=3}
lfu.get(2);      // return -1 (not found)
lfu.get(3);      // return 3
                 // cnt(3)=2
lfu.put(4, 4);   // 1 is the LFU key because cnt(1)=2 is smaller than cnt(3)=2
                 // invalidate 1.
                 // cache is {3=3, 4=4}
lfu.get(1);      // return -1 (not found)
lfu.get(3);      // return 3
                 // cnt(3)=3
lfu.get(4);      // return 4
                 // cnt(4)=3
```

## The Twist

Implementing an LFU cache with O(1) time complexity for both get and put operations. This requires maintaining frequency counts and handling ties by LRU order.

## Algorithm

### Hash Map + Doubly Linked Lists:
1. Use a hash map to store key-node pairs for O(1) access
2. Use another hash map to store frequency-doubly linked list pairs
3. Each frequency has its own doubly linked list to maintain LRU order for that frequency
4. Track the minimum frequency currently in use
5. When accessing a key (get):
   - Move the node to the next frequency list
   - Update min frequency if needed
6. When adding a key (put):
   - If key exists, update its value and move it to the next frequency
   - If key doesn't exist:
     - If cache is full, remove the least frequently used node (from min frequency list)
     - Add the new key-value pair to frequency 1 list
     - Update min frequency to 1

## Complexity

- **Time**: O(1) for both get and put operations
- **Space**: O(capacity) - storing at most capacity key-value pairs

## Solution Code

```go
package main

import "container/list"

type Node struct {
    key       int
    value     int
    frequency int
    element   *list.Element
}

type LFUCache struct {
    capacity    int
    minFreq     int
    keyToNode   map[int]*Node
    freqToList  map[int]*list.List
}

func Constructor(capacity int) LFUCache {
    return LFUCache{
        capacity:   capacity,
        minFreq:    0,
        keyToNode:  make(map[int]*Node),
        freqToList: make(map[int]*list.List),
    }
}

func (this *LFUCache) Get(key int) int {
    if node, ok := this.keyToNode[key]; ok {
        this.increaseFreq(node)
        return node.value
    }
    return -1
}

func (this *LFUCache) Put(key int, value int) {
    if this.capacity == 0 {
        return
    }
    
    if node, ok := this.keyToNode[key]; ok {
        node.value = value
        this.increaseFreq(node)
        return
    }
    
    if len(this.keyToNode) >= this.capacity {
        this.removeMinFreqNode()
    }
    
    newNode := &Node{
        key:       key,
        value:     value,
        frequency: 1,
    }
    
    this.keyToNode[key] = newNode
    this.addNodeToFreqList(newNode)
    this.minFreq = 1
}

func (this *LFUCache) increaseFreq(node *Node) {
    oldFreq := node.frequency
    oldList := this.freqToList[oldFreq]
    oldList.Remove(node.element)
    
    if oldList.Len() == 0 && oldFreq == this.minFreq {
        this.minFreq++
    }
    
    node.frequency++
    this.addNodeToFreqList(node)
}

func (this *LFUCache) addNodeToFreqList(node *Node) {
    freq := node.frequency
    if _, ok := this.freqToList[freq]; !ok {
        this.freqToList[freq] = list.New()
    }
    
    lst := this.freqToList[freq]
    node.element = lst.PushFront(node)
}

func (this *LFUCache) removeMinFreqNode() {
    lst := this.freqToList[this.minFreq]
    if lst.Len() == 0 {
        return
    }
    
    element := lst.Back()
    node := element.Value.(*Node)
    lst.Remove(element)
    
    delete(this.keyToNode, node.key)
}
```

## Link

[LeetCode 0460 LFU Cache](https://leetcode.com/problems/lfu-cache/)