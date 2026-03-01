# Minimum Possible Integer After at Most K Adjacent Swaps On Digits

## Problem Description

You are given a string `num` representing the digits of a very large integer and an integer `k`.

You are allowed to swap any two adjacent digits of the integer at most `k` times.

Return the minimum possible integer after at most `k` adjacent swaps.

**Example 1:**
```
Input: num = "4321", k = 4
Output: "1342"
Explanation: 
- Swap digits 3 and 1: "4312"
- Swap digits 4 and 3: "3412"
- Swap digits 3 and 1: "3142"
- Swap digits 3 and 1: "1342"
```

**Example 2:**
```
Input: num = "100", k = 1
Output: "010"
Explanation: Swap digits 1 and 0.
```

**Example 3:**
```
Input: num = "36789", k = 1000
Output: "36789"
Explanation: The number is already sorted in ascending order.
```

**Constraints:**
- 1 <= num.length <= 3 * 10^4
- num consists of only digits and does not contain leading zeros except for the zero itself.
- 1 <= k <= 10^9

## The Twist

This is a greedy problem where we want to place the smallest possible digit at each position, but we're limited by the number of swaps we can perform. The key insight is that we need to efficiently find the smallest digit that can be brought to the current position within k swaps.

## Algorithm

### Approach: Greedy with BIT (Fenwick Tree)

1. Convert the string to a list of characters
2. Use a BIT (Binary Indexed Tree) to track the positions of digits
3. For each position from left to right:
   - Find the smallest digit that can be brought to this position within k swaps
   - The cost to bring a digit from position j to position i is (j - i) minus the number of already removed digits between i and j
   - Use the BIT to efficiently calculate this cost
4. Remove the chosen digit from the BIT and update k
5. Repeat until all positions are filled or k becomes 0

```go
func minInteger(num string, k int) string {
    n := len(num)
    digits := []byte(num)
    
    // Create a list of positions for each digit (0-9)
    positions := make([][]int, 10)
    for i, d := range digits {
        positions[d-'0'] = append(positions[d-'0'], i)
    }
    
    // BIT to track which positions are still available
    bit := NewBIT(n)
    for i := 0; i < n; i++ {
        bit.Add(i, 1)
    }
    
    result := make([]byte, 0, n)
    
    for i := 0; i < n && k > 0; i++ {
        for d := 0; d < 10; d++ {
            if len(positions[d]) == 0 {
                continue
            }
            
            pos := positions[d][0]
            // Calculate the cost to bring this digit to position i
            // Cost = (pos - i) - (number of removed positions before pos)
            cost := bit.Query(pos) - 1
            
            if cost <= k {
                result = append(result, byte(d+'0'))
                positions[d] = positions[d][1:]
                bit.Add(pos, -1)
                k -= cost
                break
            }
        }
        
        if len(result) <= i {
            // No digit can be brought to this position within k swaps
            // Add the first available digit
            for d := 0; d < 10; d++ {
                if len(positions[d]) > 0 {
                    pos := positions[d][0]
                    result = append(result, byte(d+'0'))
                    positions[d] = positions[d][1:]
                    bit.Add(pos, -1)
                    break
                }
            }
        }
    }
    
    // Add remaining digits
    for d := 0; d < 10; d++ {
        for _, pos := range positions[d] {
            result = append(result, byte(d+'0'))
        }
    }
    
    return string(result)
}

type BIT struct {
    tree []int
    n    int
}

func NewBIT(n int) *BIT {
    return &BIT{
        tree: make([]int, n+1),
        n:    n,
    }
}

func (b *BIT) Add(i int, delta int) {
    i++
    for i <= b.n {
        b.tree[i] += delta
        i += i & (-i)
    }
}

func (b *BIT) Query(i int) int {
    i++
    sum := 0
    for i > 0 {
        sum += b.tree[i]
        i -= i & (-i)
    }
    return sum
}
```

## Complexity

- **Time Complexity:** O(n * 10 * log(n)) - For each position, we check at most 10 digits, and each BIT operation takes O(log(n))
- **Space Complexity:** O(n) - For the BIT and the positions array

## Link

[LeetCode 1505 - Minimum Possible Integer After at Most K Adjacent Swaps On Digits](https://leetcode.com/problems/minimum-possible-integer-after-at-most-k-adjacent-swaps-on-digits/)
