# 1268 Search Suggestions System

## Problem Description

You are given an array of strings `products` and a string `searchWord`.

Design a system that suggests at most three product names from `products` after each character of `searchWord` is typed. Suggested products should have common prefix with `searchWord`. If there are more than three products with a common prefix return the three lexicographically minimums products.

Return a list of lists of the suggested products after each character of `searchWord` is typed.

### Example 1:
```
Input: products = ["mobile","mouse","mousse","monitor","mousepad"], searchWord = "mouse"
Output: [["mobile","mousse","monitor"],["mobile","mousse","monitor"],["mouse","mousepad"],["mouse","mousepad"],["mouse","mousepad"]]
```

### Example 2:
```
Input: products = ["havana"], searchWord = "havana"
Output: [["havana"],["havana"],["havana"],["havana"],["havana"],["havana"]]
```

## The Twist

Implementing an efficient search suggestions system that can provide up to 3 lexicographically smallest product suggestions for each prefix of the search word.

## Algorithm

### Trie Approach:
1. Build a trie from all products
2. Each node in the trie stores up to 3 lexicographically smallest product suggestions
3. For each product:
   - Insert it into the trie character by character
   - At each node along the path, update the suggestions list if needed
4. For search suggestions:
   - Traverse the trie following the searchWord character by character
   - At each step, collect the suggestions stored at the current node
   - If a character is not found, all subsequent suggestions will be empty

The key insight is to precompute suggestions at each trie node during insertion, allowing O(1) retrieval during search.

## Complexity

- **Time**: 
  - Build trie: O(n * l) where n is number of products and l is average length
  - Search: O(m) where m is length of searchWord
- **Space**: O(n * l) - storing all products in trie with suggestions

## Solution Code

```go
package main

import "sort"

type TrieNode struct {
    children map[byte]*TrieNode
    suggestions []string
}

type SearchSuggestionsSystem struct {
    root *TrieNode
}

func Constructor(products []string) SearchSuggestionsSystem {
    root := &TrieNode{
        children: make(map[byte]*TrieNode),
        suggestions: make([]string, 0),
    }
    
    // Sort products lexicographically
    sort.Strings(products)
    
    // Insert each product into trie
    for _, product := range products {
        insert(root, product)
    }
    
    return SearchSuggestionsSystem{root: root}
}

func (this *SearchSuggestionsSystem) SuggestedProducts(searchWord string) [][]string {
    result := make([][]string, 0)
    node := this.root
    
    for i := 0; i < len(searchWord); i++ {
        char := searchWord[i]
        if node.children[char] == nil {
            // No more matches, add empty suggestions for remaining characters
            for j := i; j < len(searchWord); j++ {
                result = append(result, []string{})
            }
            break
        }
        
        node = node.children[char]
        result = append(result, node.suggestions)
    }
    
    return result
}

func insert(root *TrieNode, word string) {
    node := root
    for i := 0; i < len(word); i++ {
        char := word[i]
        if node.children[char] == nil {
            node.children[char] = &TrieNode{
                children: make(map[byte]*TrieNode),
                suggestions: make([]string, 0),
            }
        }
        
        node = node.children[char]
        
        // Add suggestions if less than 3
        if len(node.suggestions) < 3 {
            node.suggestions = append(node.suggestions, word)
        }
    }
}
```

## Link

[LeetCode 1268 Search Suggestions System](https://leetcode.com/problems/search-suggestions-system/)