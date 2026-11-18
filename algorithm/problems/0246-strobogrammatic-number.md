# 0246 Strobogrammatic Number

## Problem Description

A strobogrammatic number is a number that looks the same when rotated 180 degrees (looked at upside down).

Given a string `num` which represents an integer, return `true` if `num` is a strobogrammatic number.

### Example 1:
```
Input: num = "69"
Output: true
```

### Example 2:
```
Input: num = "88"
Output: true
```

### Example 3:
```
Input: num = "962"
Output: false
```

## The Twist

Validating **upside-down numbers**. Only certain digit pairs are valid when rotated 180 degrees.

## Hash Table Usage

- **Key**: `digit` (a character from the number)
- **Value**: `rotated_digit` (what this digit becomes when rotated 180 degrees)

Valid pairs: `{'0':'0', '1':'1', '6':'9', '8':'8', '9':'6'}`

Algorithm:
1. Create a map of valid strobogrammatic digit pairs
2. Use two pointers: left at start, right at end
3. While left <= right:
   - Check if `num[left]` maps to `num[right]`
   - If not, return false
   - Move pointers inward
4. If we complete the loop, return true

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(1) - constant size map (5 entries)

## Solution Code

### Go

```go
package main

func isStrobogrammatic(num string) bool {
	rotated := map[byte]byte{
		'0': '0',
		'1': '1',
		'6': '9',
		'8': '8',
		'9': '6',
	}

	left, right := 0, len(num)-1
	for left <= right {
		mapped, ok := rotated[num[left]]
		if !ok || mapped != num[right] {
			return false
		}
		left++
		right--
	}

	return true
}
```

Note: when `left == right` (odd-length string), the middle digit must map to itself, which the same check handles automatically (`0`, `1`, or `8`).

### Rust

```rust
use std::collections::HashMap;

pub fn is_strobogrammatic(num: String) -> bool {
    let rotated: HashMap<char, char> =
        [('0', '0'), ('1', '1'), ('6', '9'), ('8', '8'), ('9', '6')]
            .into_iter()
            .collect();

    let chars: Vec<char> = num.chars().collect();
    // right is an exclusive bound to avoid usize underflow on odd-length input
    let (mut left, mut right) = (0, chars.len());

    while left < right {
        match rotated.get(&chars[left]) {
            Some(&c) if c == chars[right - 1] => {}
            _ => return false,
        }
        left += 1;
        right -= 1;
    }

    true
}
```

For odd-length input, the loop's final iteration compares the middle digit with itself (`chars[right - 1]` is the same digit), so a middle `6` or `9` is correctly rejected.

## Link

[LeetCode 0246 Strobogrammatic Number](https://leetcode.com/problems/strobogrammatic-number/)
