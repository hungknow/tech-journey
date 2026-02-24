# 0170 Two Sum III - Data Structure Design

## Problem Description

Design a data structure that accepts a stream of integers and checks if it is possible to find two numbers that sum up to a specific target value.

Implement the `TwoSum` class:

- `TwoSum()` Initializes the `TwoSum` object.
- `void add(int number)` Adds `number` to the data structure.
- `boolean find(int value)` Returns `true` if there exists any pair of numbers whose sum is equal to `value`, otherwise returns `false`.

### Example 1:
```
Input
["TwoSum", "add", "add", "add", "find", "find"]
[[], [1], [3], [5], [4], [7]]
Output
[null, null, null, null, true, false]
```

## The Twist

Numbers are **streamed in dynamically**. Unlike the classic Two Sum where we have the entire array upfront, here numbers are added one at a time, and we need to handle queries efficiently after each addition.

## Hash Table Usage

- **Key**: `number` (the value added)
- **Value**: `frequency` (how many times this number has been added)

For the `find` operation, we iterate through the keys and check if the complement (`value - key`) exists. Special handling is needed when `key == complement` - we need at least 2 occurrences of that number.

## Complexity

- **add()**: O(1) - just update the frequency map
- **find()**: O(n) - iterate through all keys in the worst case
- **Space**: O(n) - storing unique numbers with their frequencies

## Link

[LeetCode 0170 Two Sum III](https://leetcode.com/problems/two-sum-iii-data-structure-design/)
