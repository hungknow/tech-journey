# 0249 Group Shifted Strings

## Problem Description

We can shift a string by shifting each of its letters to its successive letter. For example, "abc" can be shifted to "bcd".

Given an array of strings `strings`, group all strings that belong to the same shifting sequence. You may return the answer in any order.

### Example 1:
```
Input: strings = ["abc","bcd","acef","xyz","az","ba","a","z"]
Output: [["acef"],["a","z"],["abc","bcd"],["xyz"],["az","ba"]]
```

### Example 2:
```
Input: strings = ["a"]
Output: [["a"]]
```

## The Twist

Words can be **shifted alphabetically**. Two strings belong to the same group if one can be transformed into the other by shifting each character by the same amount.

## Hash Table Usage

- **Key**: `relative_distance` between characters (e.g., "1-1" for "abc")
- **Value**: `[list_of_strings]` (all strings with this pattern)

Algorithm:
1. For each string, compute its key by calculating the relative distance between consecutive characters
2. For "abc": b-a=1, c-b=1 → key "1-1"
3. For "bcd": c-b=1, d-c=1 → key "1-1" (same as "abc")
4. For "az": z-a=25 → key "25" (wrapping handled)
5. Use the key to group strings in the hash map

## Complexity

- **Time**: O(n * k) where n is number of strings, k is average string length (no sorting needed, just one pass per string)
- **Space**: O(n * k) - storing all strings in the map

## Solution Code

### Go

```go
package main

func groupStrings(strings []string) [][]string {
	groups := make(map[string][]string)

	for _, s := range strings {
		key := shiftKey(s)
		groups[key] = append(groups[key], s)
	}

	result := make([][]string, 0, len(groups))
	for _, group := range groups {
		result = append(result, group)
	}
	return result
}

func shiftKey(s string) string {
	key := make([]byte, 0, len(s))
	for i := 1; i < len(s); i++ {
		diff := (s[i] - s[i-1] + 26) % 26
		key = append(key, 'a'+diff)
	}
	return string(key)
}
```

### Rust

```rust
use std::collections::HashMap;

pub fn group_strings(strings: Vec<String>) -> Vec<Vec<String>> {
    let mut groups: HashMap<String, Vec<String>> = HashMap::new();

    for s in strings {
        let key: String = s
            .as_bytes()
            .windows(2)
            .map(|pair| (b'a' + (pair[1] + 26 - pair[0]) % 26) as char)
            .collect();
        groups.entry(key).or_default().push(s);
    }

    groups.into_values().collect()
}
```

## Link

[LeetCode 0249 Group Shifted Strings](https://leetcode.com/problems/group-shifted-strings/)
