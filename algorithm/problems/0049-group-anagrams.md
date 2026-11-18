# 0049 Group Anagrams

## Problem Description

Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

### Example 1:
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

### Example 2:
```
Input: strs = [""]
Output: [[""]]
```

### Example 3:
```
Input: strs = ["a"]
Output: [["a"]]
```

## The Twist

Grouping **scrambled words**. We need to identify words that are anagrams of each other and group them together.

## Hash Table Usage

- **Key**: `signature` (either the sorted string or character count tuple)
- **Value**: `[list_of_original_words]` (all words with this signature)

Two common approaches for the signature key:
1. **Sorted string**: Sort the characters of each word - "eat" → "aet", "tea" → "aet"
2. **Character count tuple**: Count each character - "eat" → (1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0)

Algorithm:
1. For each word, compute its signature key
2. Use the key to group words in the hash map
3. Return all groups from the map

## Complexity

- **Time**: O(n * k log k) where n is number of words, k is average word length (for sorting approach)
- **Space**: O(n * k) - storing all words in the map

## Solution Code

### Go

```go
package main

import "sort"

func groupAnagrams(strs []string) [][]string {
	groups := make(map[string][]string)

	for _, s := range strs {
		key := []byte(s)
		sort.Slice(key, func(i, j int) bool { return key[i] < key[j] })
		groups[string(key)] = append(groups[string(key)], s)
	}

	result := make([][]string, 0, len(groups))
	for _, group := range groups {
		result = append(result, group)
	}
	return result
}
```

### Rust

```rust
use std::collections::HashMap;

pub fn group_anagrams(strs: Vec<String>) -> Vec<Vec<String>> {
    let mut groups: HashMap<[u8; 26], Vec<String>> = HashMap::new();

    for s in strs {
        let mut count = [0u8; 26];
        for b in s.bytes() {
            count[(b - b'a') as usize] += 1;
        }
        groups.entry(count).or_default().push(s);
    }

    groups.into_values().collect()
}
```

## Link

[LeetCode 0049 Group Anagrams](https://leetcode.com/problems/group-anagrams/)
