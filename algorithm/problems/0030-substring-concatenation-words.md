# 0030 Substring with Concatenation of All Words

## Problem Description

You are given a string `s` and an array of strings `words`. All the strings of `words` are of the same length.

A concatenated substring in `s` is a substring that contains all the strings of `words` in any order and without any intervening characters.

Return the starting indices of all the concatenated substrings in `s`. You can return the answer in any order.

### Example 1:
```
Input: s = "barfoothefoobarman", words = ["foo","bar"]
Output: [0,9]
Explanation: 
- Substring starting at index 0 is "barfoo". It is the concatenation of ["bar","foo"].
- Substring starting at index 9 is "foobar". It is the concatenation of ["foo","bar"].
```

### Example 2:
```
Input: s = "wordgoodgoodgoodbestword", words = ["word","good","best","word"]
Output: []
```

### Example 3:
```
Input: s = "barfoofoobarthefoobarman", words = ["bar","foo","the"]
Output: [6,9,12]
```

## The Twist

Matching **multi-character words** instead of single letters. We need to find substrings that are concatenations of all words in any order.

## Hash Table Usage

Two frequency maps are used:
1. **Target map**: `word -> required_count` for all words in the input array
2. **Window map**: `word -> current_count` for words inside the current sliding window

Algorithm:
1. Build frequency map of all words
2. For each starting position (0 to word_length - 1):
   - Slide a window through the string in word_length steps
   - Extract words of fixed length from the window
   - Maintain window frequency map
   - If window map matches target map, record starting index

## Complexity

- **Time**: O((m + n) * k) where m is string length, n is number of words, k is word length
- **Space**: O(n * k) - storing words and their frequencies

## Solution Code

### Go

```go
package main

func findSubstring(s string, words []string) []int {
	if len(s) == 0 || len(words) == 0 {
		return []int{}
	}

	wordLen := len(words[0])
	wordCount := len(words)
	n := len(s)
	if n < wordLen*wordCount {
		return []int{}
	}

	target := make(map[string]int)
	for _, w := range words {
		target[w]++
	}

	result := []int{}

	for offset := 0; offset < wordLen; offset++ {
		window := make(map[string]int)
		left := offset
		count := 0

		for right := offset; right+wordLen <= n; right += wordLen {
			word := s[right : right+wordLen]
			if required, ok := target[word]; ok {
				window[word]++
				count++
				for window[word] > required {
					window[s[left:left+wordLen]]--
					count--
					left += wordLen
				}
				if count == wordCount {
					result = append(result, left)
				}
			} else {
				window = make(map[string]int)
				count = 0
				left = right + wordLen
			}
		}
	}

	return result
}
```

### Rust

```rust
use std::collections::HashMap;

pub fn find_substring(s: &str, words: &[&str]) -> Vec<i32> {
    if s.is_empty() || words.is_empty() {
        return Vec::new();
    }

    let s = s.as_bytes();
    let word_len = words[0].len();
    let word_count = words.len();
    if s.len() < word_len * word_count {
        return Vec::new();
    }

    let mut target: HashMap<&[u8], usize> = HashMap::new();
    for &w in words {
        *target.entry(w.as_bytes()).or_insert(0) += 1;
    }

    let mut result = Vec::new();

    for offset in 0..word_len {
        let mut window: HashMap<&[u8], usize> = HashMap::new();
        let mut left = offset;
        let mut count = 0usize;

        let mut right = offset;
        while right + word_len <= s.len() {
            let word = &s[right..right + word_len];
            if let Some(&required) = target.get(word) {
                *window.entry(word).or_insert(0) += 1;
                count += 1;
                while window[word] > required {
                    let left_word = &s[left..left + word_len];
                    *window.get_mut(left_word).unwrap() -= 1;
                    count -= 1;
                    left += word_len;
                }
                if count == word_count {
                    result.push(left as i32);
                }
            } else {
                window.clear();
                count = 0;
                left = right + word_len;
            }
            right += word_len;
        }
    }

    result
}
```

## Link

[LeetCode 0030 Substring with Concatenation of All Words](https://leetcode.com/problems/substring-with-concatenation-of-all-words/)
