# 0290 Word Pattern

## Problem Description

Given a `pattern` and a string `s`, find if `s` follows the same pattern.

Here follow means a full match, such that there is a bijection between a letter in `pattern` and a non-empty word in `s`.

### Example 1:
```
Input: pattern = "abba", s = "dog cat cat dog"
Output: true
```

### Example 2:
```
Input: pattern = "abba", s = "dog cat cat fish"
Output: false
```

### Example 3:
```
Input: pattern = "aaaa", s = "dog cat cat dog"
Output: false
```

## The Twist

Same logic as Isomorphic Strings, but mapping a `pattern_character -> whole_word` instead of character to character.

## Hash Table Usage

Two maps are used:
1. **Map 1**: `pattern_char -> word` (forward mapping)
2. **Map 2**: `word -> pattern_char` (reverse mapping for collision detection)

Algorithm:
1. Split the string `s` into words
2. Check if the number of words matches the pattern length
3. Iterate through pattern and words simultaneously
4. For each pair (pattern_char, word):
   - If pattern_char already maps to a different word, return false
   - If word is already mapped from a different pattern_char, return false
   - Otherwise, establish the mapping
5. If we complete the loop, return true

## Complexity

- **Time**: O(n) - single pass through the pattern
- **Space**: O(n) - storing mappings for each unique pattern character

## Solution Code

### Go

```go
package main

import "strings"

func wordPattern(pattern string, s string) bool {
	words := strings.Fields(s)
	if len(pattern) != len(words) {
		return false
	}

	charToWord := make(map[byte]string)
	wordToChar := make(map[string]byte)

	for i := 0; i < len(pattern); i++ {
		c, w := pattern[i], words[i]

		if mapped, ok := charToWord[c]; ok && mapped != w {
			return false
		}
		if mapped, ok := wordToChar[w]; ok && mapped != c {
			return false
		}

		charToWord[c] = w
		wordToChar[w] = c
	}

	return true
}
```

### Rust

```rust
use std::collections::HashMap;

pub fn word_pattern(pattern: &str, s: &str) -> bool {
    let words: Vec<&str> = s.split_whitespace().collect();
    let chars: Vec<char> = pattern.chars().collect();

    if chars.len() != words.len() {
        return false;
    }

    let mut char_to_word: HashMap<char, &str> = HashMap::new();
    let mut word_to_char: HashMap<&str, char> = HashMap::new();

    for (c, w) in chars.into_iter().zip(words.into_iter()) {
        if *char_to_word.entry(c).or_insert(w) != w {
            return false;
        }
        if *word_to_char.entry(w).or_insert(c) != c {
            return false;
        }
    }

    true
}
```

## Link

[LeetCode 0290 Word Pattern](https://leetcode.com/problems/word-pattern/)
