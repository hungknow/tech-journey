# 0211 Add and Search Word - Data Structure Design

## Problem Description

Design a data structure that supports adding new words and finding if a string matches any previously added string.

Implement the `WordDictionary` class:
- `WordDictionary()` Initializes the object.
- `void addWord(word)` Adds `word` to the data structure, it can be matched later.
- `bool search(word)` Returns `true` if there is any string in the data structure that matches `word` or `false` otherwise. `word` may contain dots `'.'` where a dot can match any letter.

### Example 1:
```
Input
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output
[null,null,null,null,false,true,true,true]
```

### Example 2:
```
Input
["WordDictionary","addWord","addWord","search","search","search","search","search","search"]
[[],["a"],["a"],["."],["a"],["aa"],["a"],[".a"],["a."]]
Output
[null,null,null,true,false,false,true,false,false]
```

## The Twist

The `search` method supports **wildcard dots** that can match any letter. This requires backtracking when encountering a dot to try all possible children.

## Algorithm

### Trie with DFS:
1. Use a Trie where each node has children (26 letters) and is_end flag
2. `addWord`: Traverse/create nodes for each character, mark end
3. `search`: Use DFS
   - If character is a letter: follow that child
   - If character is a dot: try all non-null children recursively
   - Return true if any path leads to a word end

## Complexity

- **addWord()**: O(m) - m is word length
- **search()**: O(26^m) worst case (all dots), O(m) average case
- **Space**: O(n * m) - storing all words

## Solution Code

### Go

```go
package main

type WordDictionary struct {
	children [26]*WordDictionary
	isEnd    bool
}

func Constructor() WordDictionary {
	return WordDictionary{}
}

func (this *WordDictionary) AddWord(word string) {
	node := this
	for i := 0; i < len(word); i++ {
		idx := word[i] - 'a'
		if node.children[idx] == nil {
			node.children[idx] = &WordDictionary{}
		}
		node = node.children[idx]
	}
	node.isEnd = true
}

func (this *WordDictionary) Search(word string) bool {
	var dfs func(node *WordDictionary, i int) bool
	dfs = func(node *WordDictionary, i int) bool {
		if i == len(word) {
			return node.isEnd
		}
		c := word[i]
		if c == '.' {
			for _, child := range node.children {
				if child != nil && dfs(child, i+1) {
					return true
				}
			}
			return false
		}
		child := node.children[c-'a']
		return child != nil && dfs(child, i+1)
	}
	return dfs(this, 0)
}

/**
 * Your WordDictionary object will be instantiated and called as such:
 * obj := Constructor();
 * obj.AddWord(word);
 * param_2 := obj.Search(word);
 */
```

### Rust

```rust
#[derive(Default)]
struct TrieNode {
    children: [Option<Box<TrieNode>>; 26],
    is_end: bool,
}

struct WordDictionary {
    root: TrieNode,
}

impl WordDictionary {
    fn new() -> Self {
        WordDictionary {
            root: TrieNode::default(),
        }
    }

    fn add_word(&mut self, word: String) {
        let mut node = &mut self.root;
        for &b in word.as_bytes() {
            let idx = (b - b'a') as usize;
            node = node.children[idx].get_or_insert_with(|| Box::new(TrieNode::default()));
        }
        node.is_end = true;
    }

    fn search(&self, word: String) -> bool {
        Self::matches(&self.root, word.as_bytes())
    }

    fn matches(node: &TrieNode, word: &[u8]) -> bool {
        match word.split_first() {
            None => node.is_end,
            Some((&b'.', rest)) => node
                .children
                .iter()
                .flatten()
                .any(|n| Self::matches(n, rest)),
            Some((&b, rest)) => match &node.children[(b - b'a') as usize] {
                Some(n) => Self::matches(n, rest),
                None => false,
            },
        }
    }
}
```

## Link

[LeetCode 0211 Add and Search Word - Data Structure Design](https://leetcode.com/problems/add-and-search-word-data-structure-design/)
