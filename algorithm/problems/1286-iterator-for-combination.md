# 1286 Iterator for Combination

## Problem Description

Design the CombinationIterator class:

- `CombinationIterator(string characters, int combinationLength)` Initializes the object with a string characters and a length combinationLength.
- `next()` Returns the next combination of length combinationLength in lexicographical order.
- `hasNext()` Returns true if there exists a next combination, or false otherwise.

### Example 1:
```
Input
["CombinationIterator", "next", "hasNext", "next", "hasNext", "next", "hasNext"]
[["abc", 2], [], [], [], [], [], []]
Output
[null, "ab", true, "ac", true, "bc", false]

Explanation
CombinationIterator itr = new CombinationIterator("abc", 2);
itr.next();    // return "ab"
itr.hasNext(); // return True
itr.next();    // return "ac"
itr.hasNext(); // return True
itr.next();    // return "bc"
itr.hasNext(); // return False
```

## The Twist

Implementing an iterator that efficiently generates combinations in lexicographical order without recomputing on each call.

## Algorithm

### Precompute + Pointer Approach:
1. Precompute all combinations of length `combinationLength` from the input string
2. Store them in lexicographical order
3. Use a pointer to track the current position in the precomputed list
4. For next():
   - Return the combination at the current pointer and increment pointer
5. For hasNext():
   - Check if pointer is within bounds of the precomputed list

The key insight is that we can generate all combinations once during initialization and then simply iterate through them.

### Alternative Backtracking Approach:
1. Use backtracking to generate combinations on-demand
2. Maintain current state (indices) to generate next combination
3. For next():
   - Generate the next combination using current indices
   - Update indices to point to the next combination
4. For hasNext():
   - Check if we can generate another combination from current state

## Complexity

- **Time**: 
  - Initialization: O(n choose k) - generate all combinations
  - next(): O(1) - just return precomputed value
  - hasNext(): O(1) - just check pointer bounds
- **Space**: O(n choose k) - store all combinations

## Solution Code

```go
package main

type CombinationIterator struct {
    combinations []string
    index        int
}

func Constructor(characters string, combinationLength int) CombinationIterator {
    combinations := make([]string, 0)
    generateCombinations(characters, combinationLength, 0, "", &combinations)
    
    return CombinationIterator{
        combinations: combinations,
        index:        0,
    }
}

func (this *CombinationIterator) Next() string {
    if this.HasNext() {
        result := this.combinations[this.index]
        this.index++
        return result
    }
    return ""
}

func (this *CombinationIterator) HasNext() bool {
    return this.index < len(this.combinations)
}

func generateCombinations(characters string, length int, start int, current string, result *[]string) {
    if len(current) == length {
        *result = append(*result, current)
        return
    }
    
    for i := start; i < len(characters); i++ {
        generateCombinations(characters, length, i+1, current + string(characters[i]), result)
    }
}
```

## Link

[LeetCode 1286 Iterator for Combination](https://leetcode.com/problems/iterator-for-combination/)