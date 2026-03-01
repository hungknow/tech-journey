# Count Good Triplets in an Array

## Problem Description

You are given two 0-indexed arrays `nums1` and `nums2` of length `n`, both of which are permutations of `[0, 1, ..., n - 1]`.

A triplet `(i, j, k)` is good if:
- `0 <= i < j < k < n`
- `nums1[i] < nums1[j] < nums1[k]`
- `nums2[i] < nums2[j] < nums2[k]`

Return the number of good triplets.

**Example 1:**
```
Input: nums1 = [2,0,1,3], nums2 = [0,1,2,3]
Output: 1
Explanation: 
Triplet (0, 2, 3) is good because:
- nums1[0] = 2 < nums1[2] = 1 < nums1[3] = 3 is false
- nums2[0] = 0 < nums2[2] = 2 < nums2[3] = 3 is true
Only triplet (1, 2, 3) satisfies both conditions.
```

**Example 2:**
```
Input: nums1 = [4,0,1,3,2], nums2 = [4,1,0,2,3]
Output: 4
Explanation: The good triplets are (0, 1, 2), (0, 1, 3), (0, 1, 4), (0, 2, 3).
```

**Constraints:**
- n == nums1.length == nums2.length
- 3 <= n <= 10^5
- 0 <= nums1[i], nums2[i] <= n - 1
- nums1 and nums2 are permutations of [0, 1, ..., n - 1]

## The Twist

This is a variant of the "Create Sorted Array Through Instructions" problem. The key insight is to use the position mapping between the two arrays and count valid triplets using a Binary Indexed Tree (Fenwick Tree).

## Algorithm

### Approach: BIT with Position Mapping

1. Create a position map from nums2 to get the position of each element in nums2
2. Transform nums1 to use the positions from nums2
3. For each element as the middle element (j), count:
   - Number of elements before j that are smaller (i candidates)
   - Number of elements after j that are larger (k candidates)
4. Multiply these counts and sum for all j

```go
func goodTriplets(nums1 []int, nums2 []int) int64 {
    n := len(nums1)
    
    // Create position map from nums2
    pos := make(map[int]int)
    for i, num := range nums2 {
        pos[num] = i
    }
    
    // Transform nums1 to positions
    transformed := make([]int, n)
    for i, num := range nums1 {
        transformed[i] = pos[num]
    }
    
    // BIT
    bit := NewBIT(n)
    
    // First pass: count smaller elements before each position
    smallerBefore := make([]int, n)
    for i, val := range transformed {
        smallerBefore[i] = bit.Query(val)
        bit.Add(val, 1)
    }
    
    // Reset BIT
    bit = NewBIT(n)
    
    // Second pass: count larger elements after each position (from right)
    largerAfter := make([]int, n)
    for i := n - 1; i >= 0; i-- {
        val := transformed[i]
        largerAfter[i] = bit.Query(n-1) - bit.Query(val)
        bit.Add(val, 1)
    }
    
    // Count good triplets
    result := int64(0)
    for i := 1; i < n-1; i++ {
        result += int64(smallerBefore[i]) * int64(largerAfter[i])
    }
    
    return result
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

- **Time Complexity:** O(n log n) - For each element, we perform O(log n) BIT operations
- **Space Complexity:** O(n) - For the BIT and the auxiliary arrays

## Link

[LeetCode 2179 - Count Good Triplets in an Array](https://leetcode.com/problems/count-good-triplets-in-an-array/)
