# 0604 Design Compressed String Iterator

## Problem Description

Design and implement a data structure for a compressed string iterator. The given compressed string `s` is of length `n` and consists of lowercase letters and spaces. The compressed string `s` is formed by concatenating groups of characters. For each group, it starts with a single lowercase letter, followed by one or more digits representing the count of that character. For example, `"a3b2c4"` means there are three `'a'`s, two `'b'`s, and four `'c'`s.

Implement the `StringIterator` class:

- `StringIterator(string compressedString)` Initializes the object with a compressed string.
- `char next()` Returns the next character if the original string still has uncompressed characters, otherwise returns a space.
- `bool hasNext()` Returns true if there are any uncompressed characters left, otherwise returns false.

### Example 1:
```
Input
["StringIterator", "next", "next", "next", "next", "next", "next", "hasNext", "next", "hasNext"]
[["L1e2t1C1o1d1e1"], [], [], [], [], [], [], [], [], []]
Output
[null, "L", "e", "e", "t", "C", "o", true, "d", true]

Explanation
StringIterator stringIterator = new StringIterator("L1e2t1C1o1d1e1");
stringIterator.next(); // return "L"
stringIterator.next(); // return "e"
stringIterator.next(); // return "e"
stringIterator.next(); // return "t"
stringIterator.next(); // return "C"
stringIterator.next(); // return "o"
stringIterator.hasNext(); // return True
stringIterator.next(); // return "d"
stringIterator.hasNext(); // return True
```

## The Twist

Implementing an iterator that efficiently decompresses a compressed string on-the-fly without precomputing the entire uncompressed string.

## Algorithm

### Lazy Decompression Approach:
1. Parse the compressed string into pairs of (character, count)
2. Keep track of current character and remaining count
3. For initialization:
   - Parse the compressed string into a list of character-count pairs
4. For next():
   - If no current character or remaining count is 0:
     - Move to next character-count pair
   - If no more pairs, return space
   - Decrement remaining count and return current character
5. For hasNext():
   - Check if there are remaining characters in current pair or more pairs to process

The key insight is to parse the compressed string once and then decompress lazily as needed.

## Complexity

- **Time**: 
  - Constructor: O(n) where n is the length of compressed string
  - next: O(1) amortized
  - hasNext: O(1)
- **Space**: O(m) where m is the number of character-count pairs

## Solution Code

```go
package main

type CharCount struct {
    char  byte
    count int
}

type StringIterator struct {
    pairs      []CharCount
    currentIdx int
    remaining  int
}

func Constructor(compressedString string) StringIterator {
    pairs := make([]CharCount, 0)
    i := 0
    n := len(compressedString)
    
    for i < n {
        // Parse character
        char := compressedString[i]
        i++
        
        // Parse count
        count := 0
        for i < n && compressedString[i] >= '0' && compressedString[i] <= '9' {
            count = count*10 + int(compressedString[i]-'0')
            i++
        }
        
        pairs = append(pairs, CharCount{char: byte(char), count: count})
    }
    
    iterator := StringIterator{
        pairs:      pairs,
        currentIdx: 0,
        remaining:  0,
    }
    
    // Initialize first character
    if len(pairs) > 0 {
        iterator.remaining = pairs[0].count
    }
    
    return iterator
}

func (this *StringIterator) Next() byte {
    if !this.HasNext() {
        return ' '
    }
    
    // Get current character
    char := this.pairs[this.currentIdx].char
    
    // Decrease remaining count
    this.remaining--
    
    // Move to next pair if current is exhausted
    if this.remaining == 0 && this.currentIdx < len(this.pairs)-1 {
        this.currentIdx++
        this.remaining = this.pairs[this.currentIdx].count
    }
    
    return char
}

func (this *StringIterator) HasNext() bool {
    return this.remaining > 0 || this.currentIdx < len(this.pairs)-1
}
```

## Link

[LeetCode 0604 Design Compressed String Iterator](https://leetcode.com/problems/design-compressed-string-iterator/)