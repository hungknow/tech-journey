# 1804 Implement Trie II (Prefix Tree)

## Problem Description

A trie (pronounced as "try") or prefix tree is a tree data structure used to efficiently store and retrieve keys in a dataset of strings. There are various applications of this data structure, such as autocomplete and spellchecker.

Implement the Trie class:

- `Trie()` Initializes the trie object.
- `void insert(String word)` Inserts the string `word` into the trie.
- `int countWordsEqualTo(String word)` Returns the number of instances of the string `word` in the trie.
- `int countWordsStartingWith(String prefix)` Returns the number of strings in the trie that have the string `prefix` as a prefix.
- `void erase(String word)` Erases the string `word` from the trie.

### Example 1:
```
Input
["Trie", "insert", "insert", "countWordsEqualTo", "countWordsStartingWith", "erase", "countWordsEqualTo", "countWordsStartingWith", "insert", "countWordsStartingWith"]
[[], ["apple"], ["apple"], ["apple"], ["app"], ["apple"], ["apple"], ["app"], ["app"], ["app"]]
Output
[null, null, null, 2, 2, null, 1, 1, null, 2]

Explanation
Trie trie = new Trie();
trie.insert("apple");               // Inserts "apple".
trie.insert("apple");               // Inserts another "apple".
trie.countWordsEqualTo("apple");    // There are two instances of "apple".
trie.countWordsStartingWith("app"); // "app" is a prefix of "apple". So return 2.
trie.erase("apple");                // Erases one "apple".
trie.countWordsEqualTo("apple");    // Now there is only one instance of "apple".
trie.countWordsStartingWith("app"); // return 1.
trie.insert("app");                 // Insert "app".
trie.countWordsStartingWith("app"); // return 2
```

## The Twist

Implementing a trie that supports counting words and prefixes, as well as erasing words. The challenge is to maintain accurate counts for all operations.

## Algorithm

### Enhanced Trie with Counters:
1. Each trie node stores:
   - A map of child nodes
   - A count of words ending at this node
   - A count of words passing through this node (prefix count)
2. For insert(word):
   - Traverse the trie character by character
   - At each node, increment the prefix count
   - At the final node, increment the word count
3. For countWordsEqualTo(word):
   - Traverse to the end of the word
   - Return the word count at the final node
4. For countWordsStartingWith(prefix):
   - Traverse to the end of the prefix
   - Return the prefix count at the final node
5. For erase(word):
   - Traverse the trie character by character
   - At each node, decrement the prefix count
   - At the final node, decrement the word count

The key insight is to maintain both word counts and prefix counts at each node to support all operations efficiently.

## Complexity

- **Time**: 
  - insert: O(n) where n is the length of the word
  - countWordsEqualTo: O(n)
  - countWordsStartingWith: O(n)
  - erase: O(n)
- **Space**: O(n * m) where n is number of words and m is average length

## Solution Code

```go
package main

type TrieNode struct {
    children map[byte]*TrieNode
    wordCount    int
    prefixCount  int
}

type Trie struct {
    root *TrieNode
}

func Constructor() Trie {
    return Trie{
        root: &TrieNode{
            children: make(map[byte]*TrieNode),
            wordCount: 0,
            prefixCount: 0,
        },
    }
}

func (this *Trie) Insert(word string)  {
    node := this.root
    node.prefixCount++
    
    for i := 0; i < len(word); i++ {
        char := word[i]
        if node.children[char] == nil {
            node.children[char] = &TrieNode{
                children: make(map[byte]*TrieNode),
                wordCount: 0,
                prefixCount: 0,
            }
        }
        node = node.children[char]
        node.prefixCount++
    }
    node.wordCount++
}

func (this *Trie) CountWordsEqualTo(word string) int {
    node := this.root
    for i := 0; i < len(word); i++ {
        char := word[i]
        if node.children[char] == nil {
            return 0
        }
        node = node.children[char]
    }
    return node.wordCount
}

func (this *Trie) CountWordsStartingWith(prefix string) int {
    node := this.root
    for i := 0; i < len(prefix); i++ {
        char := prefix[i]
        if node.children[char] == nil {
            return 0
        }
        node = node.children[char]
    }
    return node.prefixCount
}

func (this *Trie) Erase(word string)  {
    node := this.root
    node.prefixCount--
    
    for i := 0; i < len(word); i++ {
        char := word[i]
        child := node.children[char]
        child.prefixCount--
        if child.prefixCount == 0 {
            delete(node.children, char)
            return
        }
        node = child
    }
    node.wordCount--
}
```

## Link

[LeetCode 1804 Implement Trie II (Prefix Tree)](https://leetcode.com/problems/implement-trie-ii-prefix-tree/)