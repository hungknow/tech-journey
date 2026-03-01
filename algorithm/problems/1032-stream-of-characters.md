# 1032 Stream of Characters

## Problem Description

Design an algorithm that accepts a stream of characters and checks if the last `k` characters typed are equal to any of the words in `words`.

Implement the `StreamChecker` class:
- `StreamChecker(String[] words)` Initializes the object with the strings `words`.
- `boolean query(char letter)` Returns `true` if the last `k` characters typed are equal to any word in `words`, otherwise returns `false`.

### Example 1:
```
Input
["StreamChecker", "query", "query", "query", "query", "query"]
[["cd", "f", "c", "a", "t"], ["c", "d", "e", "a", "t"], ["c", "d", "e", "a", "t"], ["c", "d", "e", "a", "t"]]
Output
[null, false, false, true, true, true]
```

### Example 2:
```
Input
["StreamChecker", "query", "query", "query", "query"]
[["abc", "cd"], ["c"], ["d"], ["a"], ["b"]]
Output
[null, false, false, false]
```

## The Example 3:
```
Input
["StreamChecker", "query", "query", "query", "query", "query"]
[["ab", "cd", "bc"], ["a"], ["b"], ["c"], ["d"], ["e"]]
Output
[null, false, false, false, true]
```

## The Twist

We need to efficiently check if the **last k characters** match any word in a dictionary as characters stream in. This requires a data structure that supports prefix matching.

## Algorithm

### Trie with State Tracking:
1. Build a trie from all words
2. Maintain a queue of the last k characters processed
3. For each new character:
   - Add to queue, remove oldest if queue size > k
   - Check if any word in the trie is a prefix of the queue
   - If no word matches, return false
4. Return true if any word exactly matches the queue

### Aho-Corasick Automaton:
1. Build an Aho-Corasick automaton from all words
2. For each query, traverse the automaton with the stream
3. Check if any word ends at the current state
4. Return true if found, false otherwise

## Complexity

- **Constructor**: O(n * m) - n words, m is average word length
- **query()**: O(m) - checking against k characters
- **Space**: O(n * m) - storing the trie

## Link

[LeetCode 1032 Stream of Characters](https://leetcode.com/problems/stream-of-characters/)
