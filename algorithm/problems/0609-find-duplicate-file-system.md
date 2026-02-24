# 0609 Find Duplicate File in System

## Problem Description

Given a list `paths` of directory info, including directory path, and all the files with contents in this directory, return all the duplicate files in the file system. You may return the answer in any order.

A group of duplicate files consists of at least two files that have the same content.

The input is in the following format:
- `paths[i]` is a directory path
- Followed by one or more files in the format: `"file_name.txt file_content"`

### Example 1:
```
Input: paths = ["root/a 1.txt(abcd) 2.txt(efgh)","root/c 3.txt(abcd)","root/c/d 4.txt(efgh)","root 4.txt(efgh)"]
Output: [["root/a/1.txt","root/c/3.txt"],["root/a/2.txt","root/c/d/4.txt","root/4.txt"]]
```

### Example 2:
```
Input: paths = ["root/a 1.txt(abcd) 2.txt(efgh)","root/c 3.txt(abcd)","root/c/d 4.txt(efgh)"]
Output: [["root/a/1.txt","root/c/3.txt"],["root/a/2.txt","root/c/d/4.txt"]]
```

## The Twist

Grouping **files by content**. We need to identify files that have identical content across different directories and group them together.

## Hash Table Usage

- **Key**: `file_content` (the content string inside parentheses)
- **Value**: `[list_of_file_paths]` (all file paths with this content)

Algorithm:
1. Parse each directory entry to extract file names and contents
2. Use file content as the key in the hash map
3. Append the full file path to the list for that content
4. Return all groups with more than one file

## Complexity

- **Time**: O(n * l) where n is total number of files, l is average content length
- **Space**: O(n * l) - storing all file contents and paths

## Link

[LeetCode 0609 Find Duplicate File in System](https://leetcode.com/problems/find-duplicate-file-in-system/)
