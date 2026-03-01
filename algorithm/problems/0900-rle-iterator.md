# 0900 RLE Iterator

## Problem Description

We can use run-length encoding (i.e., RLE) to encode a sequence of integers. In a run-length encoded array of even length `encoding` (0-indexed), for all even `i`, `encoding[i]` tells us the number of times that the non-negative integer value `encoding[i + 1]` is repeated in the sequence.

For example, the sequence `arr = [3,8,0,9,2,5]` can be encoded to be `encoding = [3,8,0,9,2,5]`. `encoding = [3,8,0,9,2,5]` and the array `arr` are related to each other in the following way: `arr = [8,8,8,5,5]`. When we need to find the kth element in the array, we can use the encoding array to efficiently find the kth element.

Implement the `RLEIterator` class:

- `RLEIterator(int[] encoding)` Initializes the object with the encoded array `encoding`.
- `int next(int n)` Exhausts the next `n` elements and returns the last element in this sequence. The iteration is complete if all elements are exhausted.

### Example 1:
```
Input
["RLEIterator", "next", "next", "next", "next"]
[[[3, 8, 0, 9, 2, 5]], [2], [1], [1], [2]]
Output
[null, 8, 8, 5, -1]

Explanation
RLEIterator rLEIterator = new RLEIterator([3, 8, 0, 9, 2, 5]); // This maps to the sequence [8,8,8,5,5].
rLEIterator.next(2); // exhausts 2 terms and returns 8.
rLEIterator.next(1); // exhausts 1 term and returns 8.
rLEIterator.next(1); // exhausts 1 term and returns 5.
rLEIterator.next(2); // exhausts 2 terms, returns -1 because there are no more terms.
```

## The Twist

Implementing an iterator for run-length encoded data that efficiently skips over multiple elements without decompressing the entire sequence.

## Algorithm

### Pointer Tracking Approach:
1. Use a pointer to track current position in the encoding array
2. Track remaining count for current value
3. For initialization:
   - Store the encoding array
   - Initialize pointer to 0
4. For next(n):
   - While n > 0 and pointer is within bounds:
     - If remaining count at current position is 0:
       - Move pointer to next pair (skip 2 positions)
       - Update remaining count
     - If remaining count > 0:
       - Use min(n, remaining count) elements from current position
       - Decrease remaining count
       - Decrease n by elements used
       - Store current value as potential return value
   - If we exhausted all elements, return -1
   - Otherwise, return the last value we used

The key insight is to track our position in the encoded array and efficiently consume elements without full decompression.

## Complexity

- **Time**: 
  - Constructor: O(1)
  - next: O(k) where k is the number of pairs we skip over, amortized O(1)
- **Space**: O(1) - just storing pointer and count

## Solution Code

```go
package main

type RLEIterator struct {
    encoding []int
    index    int
    count    int
}

func Constructor(encoding []int) RLEIterator {
    return RLEIterator{
        encoding: encoding,
        index:    0,
        count:    0,
    }
}

func (this *RLEIterator) Next(n int) int {
    var result int = -1
    
    for n > 0 && this.index < len(this.encoding) {
        if this.count == 0 {
            // Move to next pair
            if this.index >= len(this.encoding) {
                return -1
            }
            this.count = this.encoding[this.index]
            if this.index+1 < len(this.encoding) {
                result = this.encoding[this.index+1]
            }
            this.index += 2
        }
        
        if this.count > 0 {
            // Use min(n, count) elements
            used := n
            if used > this.count {
                used = this.count
            }
            
            this.count -= used
            n -= used
        }
    }
    
    if n > 0 {
        return -1
    }
    
    return result
}
```

## Link

[LeetCode 0900 RLE Iterator](https://leetcode.com/problems/rle-iterator/)