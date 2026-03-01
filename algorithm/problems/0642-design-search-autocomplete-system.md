# 0642 Design Search Autocomplete System

## Problem Description

Design a search autocomplete system for a search engine. Users may input a sentence (at least one word and end with a special character '#').

You are given a string array `sentences` and an integer array `times` where `sentences[i]` is a previously typed sentence and `times[i]` is the number of times the sentence was typed. For each input character except '#', return the top 3 historical hot sentences that have the same prefix as the part of the sentence already typed.

Here are the specific rules:

1. The previous degree of hotness is actually defined as the number of times a sentence was typed.
2. The top 3 hot sentences should be sorted by hot degree (The first is the hottest one). If several sentences have the same hot degree, use ASCII code order (smaller one comes first).
3. If less than 3 hot sentences exist, return all of them.
4. If the input characters are '#', it means the input is a complete sentence and you need to store the new sentence in a system (the degree of hotness is initialized to 1), and return the empty list.

Implement the `AutocompleteSystem` class:

- `AutocompleteSystem(string[] sentences, int[] times)` Initializes the system with the previously typed `sentences` and `times`.
- `List<string> input(char c)` This is the input for each character. Returns the top 3 hot sentences for each character input.

### Example 1:
```
Input
["AutocompleteSystem", "input", "input", "input", "input"]
[[["i love you", "island", "i love leetcode"], [5, 3, 2]], ["i"], [" "], ["a"], ["#"]]
Output
[null, ["i love you", "island", "i love leetcode"], ["i love you", "i love leetcode"], [], []]

Explanation
AutocompleteSystem autocompleteSystem = new AutocompleteSystem(["i love you", "island", "i love leetcode"], [5, 3, 2]);
autocompleteSystem.input('i'); // return ["i love you", "island", "i love leetcode"]. The first character is 'i', and all sentences that start with 'i' are returned. The order is "i love you", "island", "i love leetcode" according to hot degree (5, 3, 2).
autocompleteSystem.input(' '); // return ["i love you", "i love leetcode"]. All sentences that start with 'i ' are returned. The order is "i love you", "i love leetcode" according to hot degree (5, 2).
autocompleteSystem.input('a'); // return [] since there are no sentences that start with 'i a'.
autocompleteSystem.input('#'); // store the sentence "i a" and return [].
```

## The Twist

Implementing an autocomplete system that efficiently suggests the most relevant sentences based on partial input, with dynamic updates as new sentences are added.

## Algorithm

### Trie + HashMap Approach:
1. Use a Trie data structure to store all sentences
2. Each node in the Trie contains:
   - A map of child nodes
   - A map of sentences that pass through this node with their counts
3. For initialization:
   - Insert all sentences into the Trie with their respective counts
4. For input(c):
   - If c is '#', add the current input to the Trie and reset the current input
   - Otherwise, append c to the current input and navigate the Trie
   - If the current node exists, return the top 3 sentences from its sentence map
   - Sort the sentences by count (descending) and then lexicographically
   - Return the top 3

The key insight is using a Trie to efficiently store and retrieve sentences based on prefixes, with each node maintaining a map of sentences that pass through it.

## Complexity

- **Time**: 
  - AutocompleteSystem constructor: O(p^2) where p is the total length of all sentences
  - input: O(p^2) where p is the length of the current input
- **Space**: O(p * t + s) where p is the total length of all sentences, t is the number of sentences, and s is the length of the current input

## Solution Code

```go
package main

import (
	"container/heap"
	"sort"
)

type TrieNode struct {
	children map[rune]*TrieNode
	sentences map[string]int
}

type AutocompleteSystem struct {
	root     *TrieNode
	current  *TrieNode
	input    []rune
}

func Constructor(sentences []string, times []int) AutocompleteSystem {
	root := &TrieNode{
		children: make(map[rune]*TrieNode),
		sentences: make(map[string]int),
	}
	
	for i, sentence := range sentences {
		node := root
		for _, char := range sentence {
			if _, exists := node.children[char]; !exists {
				node.children[char] = &TrieNode{
					children: make(map[rune]*TrieNode),
					sentences: make(map[string]int),
				}
			}
			node = node.children[char]
			node.sentences[sentence] = times[i]
		}
	}
	
	return AutocompleteSystem{
		root:    root,
		current: root,
		input:   make([]rune, 0),
	}
}

func (this *AutocompleteSystem) Input(c rune) []string {
	if c == '#' {
		// Add the complete sentence to the trie
		sentence := string(this.input)
		node := this.root
		for _, char := range sentence {
			if _, exists := node.children[char]; !exists {
				node.children[char] = &TrieNode{
					children: make(map[rune]*TrieNode),
					sentences: make(map[string]int),
				}
			}
			node = node.children[char]
			node.sentences[sentence]++
		}
		
		// Reset for next input
		this.current = this.root
		this.input = make([]rune, 0)
		return []string{}
	}
	
	this.input = append(this.input, c)
	
	if this.current != nil {
		if _, exists := this.current.children[c]; exists {
			this.current = this.current.children[c]
		} else {
			this.current = nil
		}
	}
	
	if this.current == nil {
		return []string{}
	}
	
	// Get all sentences and sort them
	sentences := make([]string, 0, len(this.current.sentences))
	for sentence := range this.current.sentences {
		sentences = append(sentences, sentence)
	}
	
	// Sort by count (descending) and then lexicographically
	sort.Slice(sentences, func(i, j int) bool {
		countI := this.current.sentences[sentences[i]]
		countJ := this.current.sentences[sentences[j]]
		if countI != countJ {
			return countI > countJ
		}
		return sentences[i] < sentences[j]
	})
	
	// Return top 3
	if len(sentences) > 3 {
		sentences = sentences[:3]
	}
	
	return sentences
}

/**
 * Your AutocompleteSystem object will be instantiated and called as such:
 * obj := Constructor(sentences, times);
 * param_1 := obj.Input(c);
 */
```

## Link

[LeetCode 0642 Design Search Autocomplete System](https://leetcode.com/problems/design-search-autocomplete-system/)