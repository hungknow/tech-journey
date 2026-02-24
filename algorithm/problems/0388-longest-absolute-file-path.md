# 0388 Longest Absolute File Path

## Problem Description

Given a string `input` representing the file system in the above format, return the length of the longest absolute path to a file in the abstracted file system. If there is no file in the system, return `0`.

The file system is represented in the following manner:
- `dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext`
- `\n` represents a newline
- `\t` represents a tab character
- The number of tabs indicates the depth of the file/directory

### Example 1:
```
Input: input = "dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext"
Output: 20
Explanation: The longest absolute path is "dir/subdir2/file.ext" with length 20.
```

### Example 2:
```
Input: input = "dir\n\tsubdir1\n\t\tfile1.ext\n\t\tsubsubdir1\n\tsubdir2\n\t\tsubsubdir2\n\t\t\tfile2.ext"
Output: 32
Explanation: The longest absolute path is "dir/subdir2/subsubdir2/file2.ext" with length 32.
```

## The Twist

Map stores `directory_depth -> total_string_length`. As you parse tabs (`\t`), you overwrite the length at that depth.

## Hash Table Usage

- **Key**: `depth` (the number of tabs, representing directory depth)
- **Value**: `total_length` (cumulative length up to this depth)

Algorithm:
1. Split the input by newlines
2. For each line, count the number of tabs to determine depth
3. Calculate the length of the current path (excluding tabs)
4. Update the map with the new length at this depth
5. If it's a file (contains a dot), calculate the full path length and track the maximum
6. Return the maximum file path length

## Complexity

- **Time**: O(n) - single pass through the input string
- **Space**: O(d) where d is the maximum depth of the directory tree

## Link

[LeetCode 0388 Longest Absolute File Path](https://leetcode.com/problems/longest-absolute-file-path/)
