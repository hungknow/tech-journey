# 0457 Circular Array Loop

## Problem Description

You are playing a game involving a circular array of non-zero integers `nums`. Each `nums[i]` denotes the number of steps to move forward/backward from index `i`:

- If `nums[i]` is positive, move `nums[i]` steps forward, i.e., `next index is (i + nums[i]) % n`.
- If `nums[i]` is negative, move `nums[i]` steps backward, i.e., `next index is (i - nums[i]) % n`.

Since the array is circular, you may keep moving forward or backward indefinitely.

A cycle in the array consists of a sequence of indices `seq` of length `k` where:
- Following the movement rules results in the repeating index sequence `seq[0] → seq[1] → ... → seq[k - 1] → seq[0] ...`.
- `k > 1`
- All indices in the sequence are distinct.

Return `true` if there is a cycle in `nums`, or `false` otherwise.

### Example 1:
```
Input: nums = [2, -1, 1, 2, 2]
Output: true
Explanation: There is a cycle from index 0 -> 2 -> 3 -> 0. The cycle's length is 3.
```

### Example 2:
```
Input: nums = [-1, 2]
Output: false
Explanation: The movement from index 1 -> 1 -> 1 ... is a cycle, but the cycle's length is 1.
```

## Approach

This problem can be solved using a modified Floyd's Tortoise and Hare algorithm. Here's the approach:

1. For each element in the array, treat it as a potential starting point.
2. Use two pointers (slow and fast) to detect cycles:
   - Slow pointer moves one step at a time
   - Fast pointer moves two steps at a time
3. Check if the movement is in the same direction (all positive or all negative).
4. If a cycle is detected, check if the cycle length is greater than 1.
5. Mark visited elements to avoid redundant checks.

## Solution Code

```go
func circularArrayLoop(nums []int) bool {
    n := len(nums)
    
    // Helper function to get the next index
    getNextIndex := func(index int) int {
        next := (index + nums[index]) % n
        if next < 0 {
            next += n
        }
        return next
    }
    
    for i := 0; i < n; i++ {
        // Skip if already visited or zero
        if nums[i] == 0 {
            continue
        }
        
        slow, fast := i, i
        direction := nums[i] > 0 // true for forward, false for backward
        
        // Find if there's a cycle
        for {
            // Move slow pointer one step
            nextSlow := getNextIndex(slow)
            // Check if next step is valid (same direction and not zero)
            if nums[nextSlow] == 0 || (nums[nextSlow] > 0) != direction {
                break
            }
            slow = nextSlow
            
            // Move fast pointer two steps
            nextFast := getNextIndex(fast)
            if nums[nextFast] == 0 || (nums[nextFast] > 0) != direction {
                break
            }
            nextFast = getNextIndex(nextFast)
            if nums[nextFast] == 0 || (nums[nextFast] > 0) != direction {
                break
            }
            fast = nextFast
            
            if slow == fast {
                // Check if cycle length is greater than 1
                if slow == getNextIndex(slow) {
                    break
                }
                return true
            }
        }
        
        // Mark all elements in the current traversal as visited
        j := i
        for nums[j] != 0 && (nums[j] > 0) == direction {
            next := getNextIndex(j)
            nums[j] = 0
            j = next
        }
    }
    
    return false
}
```

## Complexity Analysis

- **Time**: O(n) - Each element is visited at most twice
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 0457 Circular Array Loop](https://leetcode.com/problems/circular-array-loop/)