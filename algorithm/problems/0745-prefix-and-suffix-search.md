# 0745 Prefix and Suffix Search

## Problem Description

Design a special dictionary that searches the words in it by a prefix and a suffix.

Implement the `WordFilter` class:

- `WordFilter(string[] words)` Initializes the object with the words in the dictionary.
- `int f(string pref, string suff)` Returns the index of the word in the dictionary which has both the prefix `pref` and the suffix `suff`. If there are multiple valid answers, return the largest index. If there is no such word, return -1.

### Example 1:
```
Input
["WordFilter", "f"]
[[["apple"]], ["a", "e"]]
Output
[null, 0]

Explanation
WordFilter wordFilter = new WordFilter(["apple"]);
wordFilter.f("a", "e"); // return 0, because the word at index 0 has prefix = "a" and suffix = "e".
```

### Example 2:
```
Input
["WordFilter", "f"]
[[["ababa","abba","abbbba"]], ["ab","ba"]]
Output
[null, 2]

Explanation
WordFilter wordFilter = new WordFilter(["ababa","abba","abbbba"]);
wordFilter.f("ab", "ba"); // return 2, because "abbbba" has both prefix "ab" and suffix "ba".
```

## The Twist

Implementing a data structure that can efficiently search for words with both a given prefix and suffix. The challenge is to handle the large search space efficiently.

## Algorithm

### Trie with Combined Prefix-Suffix Approach:
1. Create a trie where each node stores the maximum index of words that pass through it
2. For each word, generate all possible prefix-suffix combinations by inserting a special separator
3. For each word at index i:
   - Generate all possible combinations of prefix + '#' + suffix
   - For example, for word "apple" and prefix "a", suffix "e", we store "a#e"
   - Insert each combination into the trie with the current index
4. For search(pref, suff):
   - Combine as pref + '#' + suff
   - Search in the trie and return the maximum index stored at the found node

The key insight is to transform the prefix-suffix search problem into a single string search problem using a separator.

## Complexity

- **Time**: 
  - Constructor: O(n * l²) where n is number of words and l is average length
  - f: O(p + s) where p is prefix length and s is suffix length
- **Space**: O(n * l²) - storing all prefix-suffix combinations

## Solution Code

```go
package main

type TrieNode struct {
    children map[byte]*TrieNode
    index    int
}

type WordFilter struct {
    root *TrieNode
}

func Constructor(words []string) WordFilter {
    root := &TrieNode{
        children: make(map[byte]*TrieNode),
        index:    -1,
    }
    
    for idx, word := range words {
        n := len(word)
        // Generate all possible prefix-suffix combinations
        for i := 0; i <= n; i++ {
            for j := 0; j <= n; j++ {
                // prefix + '#' + suffix
                combined := word[:i] + "#" + word[j:]
                insert(root, combined, idx)
            }
        }
    }
    
    return WordFilter{root: root}
}

func (this *WordFilter) F(pref string, suff string) int {
    combined := pref + "#" + suff
    return search(this.root, combined)
}

func insert(root *TrieNode, word string, index int) {
    node := root
    for i := 0; i < len(word); i++ {
        char := word[i]
        if node.children[char] == nil {
            node.children[char] = &TrieNode{
                children: make(map[byte]*TrieNode),
                index:    -1,
            }
        }
        node = node.children[char]
        // Update index to the maximum (latest) index
        if index > node.index {
            node.index = index
        }
    }
}

func search(root *TrieNode, word string) int {
    node := root
    for i := 0; i < len(word); i++ {
        char := word[i]
        if node.children[char] == nil {
            return -1
        }
        node = node.children[char]
    }
    return node.index
}
```

## Link

[LeetCode 0745 Prefix and Suffix Search](https://leetcode.com/problems/prefix-and-suffix-search/)