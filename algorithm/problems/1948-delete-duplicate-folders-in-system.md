# 1948 Delete Duplicate Folders in System

## Problem Description

Given a list of folders `folder`, return the folders after removing all sub-folders in those folders and their sub-folders. You may return the answer in any order.

If a folder[i] is located within another folder[j], it is called a sub-folder of it.

The format of a path is one or more concatenated strings of the form: `/` followed by one or more lowercase English letters. For example, `/leetcode` and `/leetcode/problems` are valid paths while an empty string and `/` are not.

### Example 1:
```
Input: folder = ["/a","/a/b","/c/d","/c/d/e","/c/f"]
Output: ["/a","/c/d","/c/f"]
Explanation: Folders "/a/b" is a subfolder of "/a" and "/c/d/e" is inside "/c/d".
```

### Example 2:
```
Input: folder = ["/a","/a/b/c","/a/b/d","/a/b/c/e","/a/b/c/f"]
Output: ["/a"]
Explanation: All folders are subfolders of "/a".
```

### Example 3:
```
Input: folder = ["/a","/c/d","/c/d/e","/c/f"]
Output: ["/a","/c/d","/c/f"]
```

## The Twist

We need to identify **duplicate folder structures** and remove sub-folders. This is similar to finding duplicate subtrees - we can use a hash map to track folder structure signatures.

## Algorithm

### Using Trie and Hash Map:
1. Build a trie from all folder paths
2. For each node, generate a signature (string representation of subtree)
3. Use a hash map to count occurrences of each signature
4. If a signature appears more than once, mark all nodes with that signature as duplicates
5. Return only non-duplicate folders

### Using Path Comparison:
1. Sort all paths by length (shorter first)
2. For each path, check if it's a subfolder of any already kept folder
3. If not a subfolder, add to result

## Complexity

- **Time**: O(n * l) where n is number of folders, l is average path length
- **Space**: O(n * l) - storing the trie or path structures

## Link

[LeetCode 1948 Delete Duplicate Folders in System](https://leetcode.com/problems/delete-duplicate-folders-in-system/)
