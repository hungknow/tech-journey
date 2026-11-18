# 0001 Two Sum

## Problem Description

Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice. You can return the answer in any order.

### Example 1:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: nums[0] + nums[1] == 9, so we return [0, 1].
```

### Example 2:
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

### Example 3:
```
Input: nums = [3,3], target = 6
Output: [0,1]
```

## Approach

This problem can be solved efficiently using a hash map:

1. **One-pass Hash Map**:
   - Iterate through the array once
   - For each element, compute the complement `target - nums[i]`
   - Check if the complement already exists in the hash map
   - If yes, return the stored index and the current index
   - Otherwise, store `nums[i] -> i` in the hash map

2. **Why it works**:
   - The hash map gives O(1) average-time lookups
   - Since exactly one solution exists, the first match found is the answer
   - By checking before inserting, we never use the same element twice

## Solution Code

### Go

```go
func twoSum(nums []int, target int) []int {
    seen := make(map[int]int, len(nums))
    for i, num := range nums {
        if j, ok := seen[target-num]; ok {
            return []int{j, i}
        }
        seen[num] = i
    }
    return nil
}
```

### Rust

```rust
use std::collections::HashMap;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut seen: HashMap<i32, i32> = HashMap::with_capacity(nums.len());
        for (i, &num) in nums.iter().enumerate() {
            if let Some(&j) = seen.get(&(target - num)) {
                return vec![j, i as i32];
            }
            seen.insert(num, i as i32);
        }
        vec![]
    }
}
```

## Complexity Analysis

- **Time**: O(n), single pass through the array with O(1) average hash map operations
- **Space**: O(n), the hash map stores at most n entries

## Link

[LeetCode 0001 Two Sum](https://leetcode.com/problems/two-sum/)
