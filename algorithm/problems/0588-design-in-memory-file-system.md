# 0588 Design In-Memory File System

## Problem Description

Design a data structure that simulates an in-memory file system.

Implement the `FileSystem` class:

- `FileSystem()` Initializes the object of the system.
- `List<String> ls(String path)`
  - If `path` is a file path, returns a list that only contains this file's name.
  - If `path` is a directory path, returns the list of file and directory names in this directory.
  - The answer should be in lexicographic order.
- `void mkdir(String path)` Creates a new directory based on the given path. If there are no intermediate directories in the path, you need to create them all.
- `void addContentToFile(String filePath, String content)`
  - If `filePath` does not exist, creates that file containing given content.
  - If `filePath` already exists, appends the given content to original content.
- `String readContentFromFile(String filePath)` Returns the content in the file.

### Example 1:
```
Input
["FileSystem", "ls", "mkdir", "addContentToFile", "ls", "readContentFromFile"]
[[], ["/"], ["/a/b/c"], ["/a/b/c/d", "hello"], ["/a"], ["/a/b/c/d"]]

Output
[null, ["a"], null, null, ["a", "b"], "hello"]

Explanation
```

## The Twist

Implementing an in-memory file system that efficiently handles directory traversal, file operations, and content management with proper path parsing.

## Algorithm

### Trie-like Structure Approach:
1. Use a trie-like structure where each node represents a directory or file
2. Each node contains:
   - A map of child nodes (subdirectories/files)
   - A flag indicating if it's a file
   - Content if it's a file
3. For ls(path):
   - Parse the path and traverse the trie
   - If it's a file, return just the filename
   - If it's a directory, return sorted list of children names
4. For mkdir(path):
   - Parse the path and create directories as needed
   - Traverse and create nodes for each directory component
5. For addContentToFile(filePath, content):
   - Parse the path and traverse to the parent directory
   - If the file doesn't exist, create it
   - Append content to the file
6. For readContentFromFile(filePath):
   - Parse the path and traverse to the file
   - Return the file's content

The key insight is using a trie-like structure to efficiently represent the hierarchical file system and enable fast navigation and operations.

## Complexity

- **Time**: 
  - ls: O(k + nlogn) where k is path length and n is number of entries in directory
  - mkdir: O(k) where k is path length
  - addContentToFile: O(k + c) where k is path length and c is content length
  - readContentFromFile: O(k + c) where k is path length and c is content length
- **Space**: O(n + s) where n is number of files/directories and s is total content size

## Solution Code

```go
package main

import (
	"sort"
	"strings"
)

type FileNode struct {
	isFile    bool
	content   string
	children  map[string]*FileNode
}

type FileSystem struct {
	root *FileNode
}

func Constructor() FileSystem {
	return FileSystem{
		root: &FileNode{
			isFile:   false,
			children: make(map[string]*FileNode),
		},
	}
}

func (this *FileSystem) Ls(path string) []string {
	if path == "/" {
		return this.getSortedKeys(this.root.children)
	}
	
	parts := strings.Split(strings.Trim(path, "/"), "/")
	node := this.root
	
	for i, part := range parts {
		if child, exists := node.children[part]; exists {
			node = child
			if i == len(parts)-1 {
				if node.isFile {
					return []string{part}
				}
				return this.getSortedKeys(node.children)
			}
		} else {
			return []string{}
		}
	}
	
	return []string{}
}

func (this *FileSystem) Mkdir(path string)  {
	parts := strings.Split(strings.Trim(path, "/"), "/")
	node := this.root
	
	for _, part := range parts {
		if _, exists := node.children[part]; !exists {
			node.children[part] = &FileNode{
				isFile:   false,
				children: make(map[string]*FileNode),
			}
		}
		node = node.children[part]
	}
}

func (this *FileSystem) AddContentToFile(filePath string, content string)  {
	parts := strings.Split(strings.Trim(filePath, "/"), "/")
	node := this.root
	
	// Navigate to parent directory
	for i := 0; i < len(parts)-1; i++ {
		part := parts[i]
		if _, exists := node.children[part]; !exists {
			node.children[part] = &FileNode{
				isFile:   false,
				children: make(map[string]*FileNode),
			}
		}
		node = node.children[part]
	}
	
	// Create or update the file
	fileName := parts[len(parts)-1]
	if _, exists := node.children[fileName]; !exists {
		node.children[fileName] = &FileNode{
			isFile:   true,
			content:  "",
			children: nil,
		}
	}
	
	node.children[fileName].content += content
}

func (this *FileSystem) ReadContentFromFile(filePath string) string {
	parts := strings.Split(strings.Trim(filePath, "/"), "/")
	node := this.root
	
	for _, part := range parts {
		if child, exists := node.children[part]; exists {
			node = child
		} else {
			return ""
		}
	}
	
	if node.isFile {
		return node.content
	}
	
	return ""
}

func (this *FileSystem) getSortedKeys(children map[string]*FileNode) []string {
	keys := make([]string, 0, len(children))
	for key := range children {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	return keys
}
```

## Link

[LeetCode 0588 Design In-Memory File System](https://leetcode.com/problems/design-in-memory-file-system/)