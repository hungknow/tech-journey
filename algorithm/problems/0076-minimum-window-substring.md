# 0076 Minimum Window Substring

## Problem Description

Given two strings `s` and `t`, return the minimum window substring of `s` such that every character in `t` (including duplicates) is included in the window. If there is no such substring, return the empty string `""`.

A substring is a contiguous sequence of characters within the string.

### Example 1:
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.
```

### Example 2:
```
Input: s = "a", t = "a"
Output: "a"
```

### Example 3:
```
Input: s = "a", t = "aa"
Output: ""
Explanation: Both 'a's from t must be included in the window.
```

## The Twist

Finding the **smallest window** containing all target characters. We need to expand and contract a sliding window while tracking character frequencies.

## Hash Table Usage

- **Key**: `character` (from string t)
- **Value**: `required_count` (how many times this character is needed)

Algorithm:
1. Build frequency map of characters in `t`
2. Use two pointers: `left` and `right` for window boundaries
3. Expand `right` pointer, decreasing required counts for characters found
4. When all required characters are satisfied (formed == required), try to contract from `left`
5. Track the minimum valid window found

## Complexity

- **Time**: O(n) - each character is visited at most twice
- **Space**: O(k) where k is the number of unique characters in `t`

## Solution Code

### Go

```go
package main

func minWindow(s string, t string) string {
	if len(t) > len(s) {
		return ""
	}

	// need[c] > 0 means the window still needs that many of character c
	var need [128]int
	for i := 0; i < len(t); i++ {
		need[t[i]]++
	}

	required := len(t)
	bestLeft, bestLen := 0, 0
	left := 0

	for right := 0; right < len(s); right++ {
		c := s[right]
		if need[c] > 0 {
			required--
		}
		need[c]--

		// Window covers all of t; contract from the left to shrink it
		for required == 0 {
			if bestLen == 0 || right-left+1 < bestLen {
				bestLeft = left
				bestLen = right - left + 1
			}
			l := s[left]
			need[l]++
			if need[l] > 0 {
				required++
			}
			left++
		}
	}

	if bestLen == 0 {
		return ""
	}
	return s[bestLeft : bestLeft+bestLen]
}
```

### Rust

```rust
pub fn min_window(s: &str, t: &str) -> String {
    let (s, t) = (s.as_bytes(), t.as_bytes());

    if t.len() > s.len() {
        return String::new();
    }

    // need[c] > 0 means the window still needs that many of character c
    let mut need = [0i32; 128];
    for &c in t {
        need[c as usize] += 1;
    }

    let mut required = t.len() as i32;
    let (mut best_left, mut best_len) = (0usize, 0usize);
    let mut left = 0usize;

    for right in 0..s.len() {
        let c = s[right] as usize;
        if need[c] > 0 {
            required -= 1;
        }
        need[c] -= 1;

        // Window covers all of t; contract from the left to shrink it
        while required == 0 {
            if best_len == 0 || right - left + 1 < best_len {
                best_left = left;
                best_len = right - left + 1;
            }
            let l = s[left] as usize;
            need[l] += 1;
            if need[l] > 0 {
                required += 1;
            }
            left += 1;
        }
    }

    if best_len == 0 {
        String::new()
    } else {
        String::from_utf8_lossy(&s[best_left..best_left + best_len]).into_owned()
    }
}
```

## Link

[LeetCode 0076 Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/)
