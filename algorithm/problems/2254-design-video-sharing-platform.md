# 2254 Design Video Sharing Platform

## Problem Description

Design a video sharing platform that supports the following operations:

- `VideoSharing(int capacity)` Initializes the object with the given capacity.
- `int upload(string video)` Uploads the video with the given name.
- `int remove(string video)` Removes the video with the given name.
- `int watch(string video, int startMinute, int endMinute)` Watches the video from start to end minutes.
- `int like(string video, int startMinute, int endMinute)` Likes the video from start to end minutes.

### Example 1:
```
Input
["VideoSharing","upload","remove","upload","watch","like","like","watch","like","watch"]
[[1],["hello"],["hello"],["hello"],[1,2],[3,5],[1,2],[3,5],[1,2],[3,5]]
Output
[null,1,0,1,1,1,0,1]

Explanation
VideoSharing videoSharing = new VideoSharing(1);
videoSharing.upload("hello");    // return 1
videoSharing.upload("hello");    // return 0, already exists
videoSharing.remove("hello");   // return 1
videoSharing.upload("hello");    // return 2
videoSharing.watch("hello", 1, 3); // return 1
videoSharing.like("hello", 1, 3); // return 1
videoSharing.like("hello", 3, 5); // return 0
videoSharing.watch("hello", 1, 5); // return 0
```

## The Twist

Implementing a video sharing platform that efficiently tracks videos, views, and likes with proper capacity management.

## Algorithm

### HashMap + LRU Cache Approach:
1. Use a HashMap to store video information (views, likes, timestamps)
2. Use an LRU cache to track the most recently used videos
3. For VideoSharing(capacity):
   - Initialize the HashMap and LRU cache
4. For upload(video):
   - If video exists, return its ID
   - If capacity is reached, remove the least recently used video
   - Add new video to HashMap and LRU cache
5. For remove(video):
   - Remove from HashMap and LRU cache
6. For watch(video, start, end):
   - Increment view count for the given time range
7. For like(video, start, end):
   - Increment like count for the given time range

The key insight is using an LRU cache to efficiently manage capacity and a HashMap for quick lookups.

## Complexity

- **Time**: 
  - VideoSharing constructor: O(1)
  - upload: O(1) average
  - remove: O(1)
  - watch: O(1)
  - like: O(1)
- **Space**: O(n) where n is the number of videos

## Solution Code

```go
package main

import "container/list"

type Video struct {
	id       int
	views    int
	likes    int
	watching  int
}

type LRUNode struct {
	key   string
	value int
	prev  *LRUNode
	next  *LRUNode
}

type LRU struct {
	capacity int
	cache    map[string]*LRUNode
	head     *LRUNode
	tail     *LRUNode
}

func Constructor(capacity int) LRU {
	return LRU{
		capacity: capacity,
		cache:    make(map[string]*LRUNode),
	}
}

func (this *LRU) Get(key string) (int, bool) {
	if node, exists := this.cache[key]; exists {
		// Move to front
		this.moveToFront(node)
		return node.value, true
	}
	return 0, false
}

func (this *LRU) Put(key string, value int) {
	if node, exists := this.cache[key]; exists {
		// Update value
		node.value = value
		this.moveToFront(node)
	} else {
		// Add new node
		node := &LRUNode{
			key:   key,
			value: value,
		}
		this.cache[key] = node
		
		if this.head == nil {
			// First node
			this.head = node
			this.tail = node
		} else {
			// Add to front
			node.prev = nil
			node.next = this.head
			this.head.prev = node
			this.head.next = node
		}
		
		if this.capacity > 0 && len(this.cache) > this.capacity {
			// Remove least recently used
			delete(this.cache, this.tail.key)
			this.removeNode(this.tail)
		}
	}
}

func (this *LRU) moveToFront(node *LRUNode) {
	if node.prev != nil {
		node.prev.next = node.next
	}
	if node.next != nil {
		node.next.prev = node.prev
	}
	
	if node == this.head {
		this.head = node.next
	} else {
		node.prev.next = this.head
		this.head.prev = node
		this.head = node
	}
	
	if node == this.tail {
		this.tail = node.prev
	} else {
		node.next.prev = this.tail
		this.tail.prev = node.next
		this.tail = node
	}
}

func (this *LRU) removeNode(node *LRUNode) {
	if node.prev != nil {
		node.prev.next = node.next
	} else {
		this.head = node.next
	}
	
	if node.next != nil {
		node.next.prev = node.prev
	} else {
		this.tail = node.prev
	}
	
	delete(this.cache, node.key)
}

type VideoSharing struct {
	videos    map[string]*Video
	lru       *LRU
	nextID    int
}

func Constructor(capacity int) VideoSharing {
	return VideoSharing{
		videos: make(map[string]*Video),
		lru:    Constructor(capacity),
		nextID: 1,
	}
}

func (this *VideoSharing) Upload(video string) int {
	if _, exists := this.videos[video]; exists {
		// Return existing video ID
		return this.videos[video].id
	}
	
	// Check capacity
	if this.lru.capacity > 0 && len(this.videos) >= this.lru.capacity {
		// Remove least recently used
		if key, _ := this.lru.Get(this.lru.tail.key); key != "" {
			delete(this.videos, key)
		}
	}
	
	// Add new video
	this.videos[video] = &Video{
		id:       this.nextID,
		views:    0,
		likes:    0,
		watching:  0,
	}
	this.lru.Put(video, this.nextID)
	this.nextID++
	
	return this.nextID - 1
}

func (this *VideoSharing) Remove(video string) int {
	if v, exists := this.videos[video]; exists {
		delete(this.videos, video)
		this.lru.cache[video] = nil
		return v.id
	}
	
	return -1
}

func (this *VideoSharing) Watch(video string, startMinute int, endMinute int) int {
	if v, exists := this.videos[video]; exists {
		for i := startMinute; i <= endMinute; i++ {
			if i >= v.watching && i <= endMinute {
				v.watching++
			}
		}
		v.views++
		this.lru.Put(video, v.id)
		return v.views
	}
	
	return 0
}

func (this *VideoSharing) Like(video string, startMinute int, endMinute int) int {
	if v, exists := this.videos[video]; exists {
		for i := startMinute; i <= endMinute; i++ {
			if i >= v.watching && i <= endMinute {
				v.likes++
			}
		}
		this.lru.Put(video, v.id)
		return v.likes
	}
	
	return 0
}

/**
 * Your VideoSharing object will be instantiated and called as such:
 * obj := Constructor(capacity);
 * param_1 := obj.Upload(video);
 * param_2 := obj.Remove(video);
 * param_3 := obj.Watch(video,startMinute,endMinute);
 * param_4 := obj.Like(video,startMinute,endMinute);
 */
```

## Link

[LeetCode 2254 Design Video Sharing Platform](https://leetcode.com/problems/design-video-sharing-platform/)