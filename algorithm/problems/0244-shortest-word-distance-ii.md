# 0244 Shortest Word Distance II

## Problem Description

Design a class that receives a list of words in the constructor and implements a method that takes two words `word1` and `word2` and returns the shortest distance between these two words in the list.

### Example 1:
```
Input: 
WordDistance(["practice", "makes", "perfect", "coding", "makes"])
shortest("coding", "practice") → 3
shortest("makes", "coding") → 1
```

### Example 2:
```
Input: 
WordDistance(["a","b","c","d","d"])
shortest("a","d") → 3
shortest("d","a") → 3
```

## The Twist

We need to efficiently answer multiple distance queries. Preprocessing the word positions allows O(a + b) lookup time where a and b are the frequencies of the two words.

## Hash Table Usage

- **Key**: `word` (a word from the list)
- **Value**: `[list_of_indices]` (all positions where this word appears)

Algorithm:
1. Constructor: Build a map from each word to its list of indices
2. shortest(word1, word2):
   - Get the two index lists
   - Use two pointers to find the minimum difference between any pair of indices
   - Return the minimum distance

## Complexity

- **Time**: O(n) for constructor, O(a + b) for each query
- **Space**: O(n) - storing all word indices

## Solution Code

### Go

```go
package main

import "math"

type WordDistance struct {
	indices map[string][]int
}

func Constructor(wordsDict []string) WordDistance {
	indices := make(map[string][]int)
	for i, word := range wordsDict {
		indices[word] = append(indices[word], i)
	}
	return WordDistance{indices: indices}
}

func (this *WordDistance) Shortest(word1 string, word2 string) int {
	l1, l2 := this.indices[word1], this.indices[word2]
	minDist := math.MaxInt32
	i, j := 0, 0
	for i < len(l1) && j < len(l2) {
		dist := l1[i] - l2[j]
		if dist < 0 {
			dist = -dist
		}
		if dist < minDist {
			minDist = dist
		}
		if l1[i] < l2[j] {
			i++
		} else {
			j++
		}
	}
	return minDist
}

/**
 * Your WordDistance object will be instantiated and called as such:
 * obj := Constructor(wordsDict);
 * param_1 := obj.Shortest(word1,word2);
 */
```

### Rust

```rust
use std::collections::HashMap;

struct WordDistance {
    indices: HashMap<String, Vec<i32>>,
}

impl WordDistance {
    fn new(words_dict: Vec<String>) -> Self {
        let mut indices: HashMap<String, Vec<i32>> = HashMap::new();
        for (i, word) in words_dict.iter().enumerate() {
            indices.entry(word.clone()).or_default().push(i as i32);
        }
        WordDistance { indices }
    }

    fn shortest(&self, word1: String, word2: String) -> i32 {
        let l1 = &self.indices[&word1];
        let l2 = &self.indices[&word2];
        let mut min_dist = i32::MAX;
        let (mut i, mut j) = (0, 0);
        while i < l1.len() && j < l2.len() {
            min_dist = min_dist.min((l1[i] - l2[j]).abs());
            if l1[i] < l2[j] {
                i += 1;
            } else {
                j += 1;
            }
        }
        min_dist
    }
}
```

## Link

[LeetCode 0244 Shortest Word Distance II](https://leetcode.com/problems/shortest-word-distance-ii/)
