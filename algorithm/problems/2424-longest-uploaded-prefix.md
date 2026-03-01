# 2424 Longest Uploaded Prefix

## Problem Description

Design a system to track the longest uploaded prefix of a file sharing system.

Implement the `LUPrefix` class:

- `LUPrefix()` Initializes the object with an empty system.
- `void upload(string video)` Uploads the video with the given name.
- `int longest(string video)` Returns the length of the longest common prefix among all uploaded videos.

### Example 1:
```
Input
["LUPrefix","upload","upload","upload","upload","upload","longest","longest","upload","longest"]
[[],["hello"],["hello"],["hello"],["hello"],["hello"]]
Output
[null,1,1,2]

Explanation
LUPrefix lu = new LUPrefix();
lu.upload("hello");    // return 1
lu.upload("hello");    // return 1
lu.upload("hello");    // return 1
lu.longest("hello");    // return 2, longest common prefix is "hello" with length 5
lu.longest("hello");    // return 2, longest common prefix is "hello" with length 5
```

## The Twist

Implementing a system that efficiently tracks uploaded videos and can find the longest common prefix among them.

## Algorithm

### Trie + HashMap Approach:
1. Use a Trie to store all uploaded video names
2. For LUPrefix():
   - Initialize empty Trie and HashMap
3. For upload(video):
   - Insert the video name into the Trie
   - Update the count in the HashMap
4. For longest(video):
   - For each node in the Trie:
     - If the current node is a word and has children:
       - Update the longest prefix if necessary
   - Return the longest prefix length

The key insight is using a Trie to efficiently track prefixes and update the longest prefix during uploads.

## Complexity

- **Time**: 
  - LUPrefix constructor: O(1)
  - upload: O(n) where n is the length of the video name
  - longest: O(n) where n is the total number of characters in all video names
- **Space**: O(n) where n is the total number of characters in all video names

## Solution Code

```go
package main

import "strings"

type TrieNode struct {
	children map[rune]*TrieNode
	isWord   bool
}

type LUPrefix struct {
	root    *TrieNode
	uploads map[string]int
	maxLen  int
}

func Constructor() LUPrefix {
	return LUPrefix{
		root: &TrieNode{
			children: make(map[rune]*TrieNode),
		},
		uploads: make(map[string]int),
		maxLen: 0,
	}
}

func (this *LUPrefix) Upload(video string) int {
	// Insert into Trie
	node := this.root
	for _, char := range video {
		if _, exists := node.children[char]; !exists {
			node.children[char] = &TrieNode{
				isWord: false,
				children: make(map[rune]*TrieNode),
			}
		}
		node = node.children[char]
	}
	
	// Mark as word
	node.isWord = true
	this.uploads[video]++
	
	// Update max length
	if len(video) > this.maxLen {
		this.maxLen = len(video)
	}
	
	return 0
}

func (this *LUPrefix) Longest(video string) int {
	node := this.root
	maxLen := 0
	
	// Find the longest common prefix
	this.findLongestPrefix(node, video, 0, &maxLen)
	
	return maxLen
}

func (this *LUPrefix) findLongestPrefix(node *TrieNode, video string, depth int, maxLen *int) {
	if node.isWord {
		if depth > *maxLen {
			*maxLen = depth
		}
		return
	}
	
	for char, child := range node.children {
		if child != nil {
			newDepth := depth + 1
			this.findLongestPrefix(child, video, newDepth, maxLen)
		}
	}
}

/**
 * Your LUPrefix object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.Upload(video);
 * param_2 := obj.Longest(video);
 */
```

## Link

[LeetCode 2424 Longest Uploaded Prefix](https://leetcode.com/problems/longest-uploaded-prefix/)