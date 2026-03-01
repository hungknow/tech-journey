# 1166 Design File System

## Problem Description

You are asked to design a file system that allows creating files, reading files, and creating directories.

Implement the `FileSystem` class:

- `FileSystem()` Initializes the object of the system.
- `bool createPath(string path, int value)` Creates a new path and stores a value in it. Returns `true` if and only if the path didn't exist before and was successfully created. The parent directories should all exist when creating the path.
- `int get(string path)` Returns the value associated with `path`. Returns `-1` if the path doesn't exist.

### Example 1:
```
Input
["FileSystem", "createPath", "get"]
[[], ["/leet", 1], ["/leet"]]

Output
[null, true, 1]

Explanation
FileSystem fileSystem = new FileSystem();
fileSystem.createPath("/leet", 1); // return true
fileSystem.get("/leet"); // return 1
```

### Example 2:
```
Input
["FileSystem", "createPath", "createPath", "get", "get"]
[[], ["/leet", 1], ["/leet/code", 2], ["/leet/code"], ["/c"]]

Output
[null, true, true, 2, -1]

Explanation
FileSystem fileSystem = new FileSystem();
fileSystem.createPath("/leet", 1); // return true
fileSystem.createPath("/leet/code", 2); // return true
fileSystem.get("/leet/code"); // return 2
fileSystem.get("/c"); // return -1
```

## The Twist

Implementing a file system that efficiently handles path creation and retrieval with proper validation of parent directories.

## Algorithm

### Trie-like Structure Approach:
1. Use a trie-like structure where each node represents a directory or file
2. Each node contains:
   - A map of child nodes
   - A value (for files only)
   - A flag indicating if it's a file
3. For createPath(path, value):
   - Split the path into components
   - Traverse the trie to check if all parent directories exist
   - If any parent doesn't exist or the path already exists, return false
   - Otherwise, create the new path with the given value and return true
4. For get(path):
   - Split the path into components
   - Traverse the trie to find the node
   - If the node doesn't exist or is not a file, return -1
   - Otherwise, return the stored value

The key insight is using a trie-like structure to efficiently represent the hierarchical file system and enable fast navigation and operations.

## Complexity

- **Time**: 
  - createPath: O(n) where n is the length of the path
  - get: O(n) where n is the length of the path
- **Space**: O(n) where n is the total number of paths created

## Solution Code

```go
package main

import (
	"strings"
)

type FileNode struct {
	children map[string]*FileNode
	value    int
	isFile   bool
}

type FileSystem struct {
	root *FileNode
}

func Constructor() FileSystem {
	return FileSystem{
		root: &FileNode{
			children: make(map[string]*FileNode),
		},
	}
}

func (this *FileSystem) CreatePath(path string, value int) bool {
	if path == "" || path[0] != '/' {
		return false
	}
	
	components := strings.Split(strings.Trim(path, "/"), "/")
	if len(components) == 0 {
		return false
	}
	
	current := this.root
	
	// Check if all parent directories exist
	for i := 0; i < len(components)-1; i++ {
		component := components[i]
		if _, exists := current.children[component]; !exists {
			return false
		}
		current = current.children[component]
	}
	
	// Check if the path already exists
	lastComponent := components[len(components)-1]
	if _, exists := current.children[lastComponent]; exists {
		return false
	}
	
	// Create the new file
	current.children[lastComponent] = &FileNode{
		children: make(map[string]*FileNode),
		value:    value,
		isFile:   true,
	}
	
	return true
}

func (this *FileSystem) Get(path string) int {
	if path == "" || path[0] != '/' {
		return -1
	}
	
	components := strings.Split(strings.Trim(path, "/"), "/")
	if len(components) == 0 {
		return -1
	}
	
	current := this.root
	
	for _, component := range components {
		if _, exists := current.children[component]; !exists {
			return -1
		}
		current = current.children[component]
	}
	
	if current.isFile {
		return current.value
	}
	
	return -1
}

/**
 * Your FileSystem object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.CreatePath(path,value);
 * param_2 := obj.Get(path);
 */
```

## Link

[LeetCode 1166 Design File System](https://leetcode.com/problems/design-file-system/)