# 2166 Design Bitset

## Problem Description

Design a bitset data structure that supports the following operations:

- `Bitset(int size)` Initializes the object with the given size.
- `void fix(int idx)` Sets the bit at index `idx` to 1.
- `void unfix(int idx)` Sets the bit at index `idx` to 0.
- `void flip()` Flips all the bits in the bitset.
- `boolean all()` Returns true if all bits are set to 1, false otherwise.
- `boolean one()` Returns true if at least one bit is set to 1, false otherwise.
- `int count()` Returns the total number of set bits.
- `String toString()` Returns a string representation of the bitset.

### Example 1:
```
Input
["Bitset","fix","fix","flip","all","one","count","toString"]
[[5],[3],[1],[],[],[],[]]
Output
[null,null,null,true,true,2,"01010"]

Explanation
Bitset bs = new Bitset(5); // bitset = 00000
bs.fix(3);             // bitset = 00100
bs.fix(1);             // bitset = 00101
bs.flip();              // bitset = 11010
bs.all();               // return false
bs.one();               // return true
bs.count();             // return 2
bs.toString();           // return "01010"
```

## The Twist

Implementing a bitset data structure that efficiently supports bit manipulation operations with proper boundary checking.

## Algorithm

### Array + Bit Operations Approach:
1. Use an array of integers to store the bitset
2. For Bitset(size):
   - Initialize an array of size/32 integers
3. For fix(idx):
   - Set the bit at the given index
4. For unfix(idx):
   - Clear the bit at the given index
5. For flip():
   - Flip all bits by XOR with all 1s
6. For all():
   - Check if all bits are set
7. For one():
   - Check if any bit is set
8. For count():
   - Count set bits using bit operations
9. For toString():
   - Convert each integer to binary string representation

The key insight is using an array of integers to store the bitset and using bitwise operations for efficient manipulation.

## Complexity

- **Time**: 
  - Bitset constructor: O(n/32) where n is the size
  - fix: O(1)
  - unfix: O(1)
  - flip: O(n/32) where n is the size
  - all: O(n/32) where n is the size
  - one: O(n/32) where n is the size
  - count: O(n/32) where n is the size
  - toString: O(n) where n is the size
- **Space**: O(n/32) where n is the size

## Solution Code

```go
package main

import (
	"fmt"
	"strconv"
	"strings"
)

type Bitset struct {
	bits   []int
	size   int
}

func Constructor(size int) Bitset {
	// Calculate number of integers needed
	intCount := (size + 31) / 32
	
	bits := make([]int, intCount)
	
	return Bitset{
		bits: bits,
		size: size,
	}
}

func (this *Bitset) Fix(idx int)  {
	if idx < 0 || idx >= this.size {
		return
	}
	
	intIndex := idx / 32
	bitIndex := idx % 32
	
	this.bits[intIndex] |= 1 << uint(bitIndex)
}

func (this *Bitset) Unfix(idx int)  {
	if idx < 0 || idx >= this.size {
		return
	}
	
	intIndex := idx / 32
	bitIndex := idx % 32
	
	this.bits[intIndex] &= ^(1 << uint(bitIndex))
}

func (this *Bitset) Flip()  {
	// Flip all bits
	for i := 0; i < len(this.bits); i++ {
		this.bits[i] = ^this.bits[i]
	}
}

func (this *Bitset) All() bool {
	for i := 0; i < len(this.bits); i++ {
		if this.bits[i] != ^0 {
			return false
		}
	}
	
	// Check remaining bits
	remainingBits := this.size % 32
	if remainingBits == 0 {
		return true
	}
	
	mask := (1 << uint(remainingBits)) - 1
	return (this.bits[len(this.bits)-1] & mask) == 0
}

func (this *Bitset) One() bool {
	for _, bits := range this.bits {
		if bits != 0 {
			return true
		}
	}
	
	// Check remaining bits
	remainingBits := this.size % 32
	if remainingBits == 0 {
		return false
	}
	
	mask := (1 << uint(remainingBits)) - 1
	return (this.bits[len(this.bits)-1] & mask) != 0
}

func (this *Bitset) Count() int {
	count := 0
	for _, bits := range this.bits {
		count += countOnes(bits)
	}
	
	// Count remaining bits
	remainingBits := this.size % 32
	if remainingBits > 0 {
		mask := (1 << uint(remainingBits)) - 1
		count += countOnes(this.bits[len(this.bits)-1] & mask)
	}
	
	return count
}

func (this *Bitset) ToString() string {
	var result strings.Builder
	
	for i := 0; i < this.size; i++ {
		intIndex := i / 32
		bitIndex := i % 32
		
		if this.bits[intIndex]&(1<<uint(bitIndex)) != 0 {
			result.WriteString("1")
		} else {
			result.WriteString("0")
		}
	}
	
	return result.String()
}

func countOnes(n int) int {
	count := 0
	for n > 0 {
		count += n & 1
		n >>= 1
	}
	return count
}

/**
 * Your Bitset object will be instantiated and called as such:
 * obj := Constructor(size);
 * obj.Fix(idx);
 * obj.Unfix(idx);
 * obj.Flip();
 * obj.All();
 * obj.One();
 * obj.Count();
 * param_8 := obj.ToString();
 */
```

## Link

[LeetCode 2166 Design Bitset](https://leetcode.com/problems/design-bitset/)