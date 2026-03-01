# 1352 Product of the Last K Numbers

## Problem Description

Design an algorithm that accepts a stream of integers and retrieves the product of the last K integers of the stream.

Implement the `ProductOfNumbers` class:

- `ProductOfNumbers()` Initializes the object with an empty stream.
- `void add(int num)` Appends integer num to the stream.
- `int getProduct(int k)` Returns the product of the last k numbers in the current list. You can assume that always the current list has at least k numbers.

### Example 1:
```
Input
["ProductOfNumbers","add","add","add","add","getProduct","getProduct","getProduct","add","getProduct"]
[[],[3],[0],[2],[5],[3],[4],[2],[4],[3]]
Output
[null,null,null,null,null,20,40,0,null,32]

Explanation
ProductOfNumbers productOfNumbers = new ProductOfNumbers();
productOfNumbers.add(3);        // [3]
productOfNumbers.add(0);        // [3,0]
productOfNumbers.add(2);        // [3,0,2]
productOfNumbers.add(5);        // [3,0,2,5]
productOfNumbers.getProduct(3); // return 0. The product of the last 3 numbers is 0 * 2 * 5 = 0
productOfNumbers.getProduct(4); // return 20. The product of the last 4 numbers is 3 * 0 * 2 * 5 = 0
productOfNumbers.getProduct(2); // return 40. The product of the last 2 numbers is 2 * 5 = 10
productOfNumbers.add(4);        // [3,0,2,5,4]
productOfNumbers.getProduct(3); // return 32. The product of the last 3 numbers is 2 * 5 * 4 = 40
```

## The Twist

Implementing a data structure that efficiently tracks the product of the last K numbers in a stream, handling the special case when zeros are encountered.

## Algorithm

### Prefix Product with Zero Tracking Approach:
1. Use a list to store prefix products
2. Initialize with 1 (empty product)
3. For add(num):
   - If num is 0:
     - Store the current length before the zero
     - Reset prefix product to 1
   - Otherwise:
     - Multiply the last prefix product by num
     - Store the new prefix product
4. For getProduct(k):
   - If k exceeds the current size, return 0
   - If there was a zero in the last k elements:
     - Return 0
   - Otherwise:
     - Return current prefix product / prefix product at position size-k

The key insight is tracking prefix products and handling zeros specially to avoid division by zero issues.

## Complexity

- **Time**: 
  - ProductOfNumbers constructor: O(1)
  - add: O(1)
  - getProduct: O(1)
- **Space**: O(n) where n is the number of elements in the stream

## Solution Code

```go
package main

type ProductOfNumbers struct {
	prefixProducts []int
	zeroIndices   []int
	size          int
}

func Constructor() ProductOfNumbers {
	return ProductOfNumbers{
		prefixProducts: []int{1}, // Initialize with 1 for empty product
		zeroIndices:   make([]int, 0),
		size:          0,
	}
}

func (this *ProductOfNumbers) Add(num int)  {
	this.size++
	
	if num == 0 {
		this.zeroIndices = append(this.zeroIndices, this.size)
		this.prefixProducts = append(this.prefixProducts, 1) // Reset to 1 after zero
	} else {
		lastProduct := this.prefixProducts[len(this.prefixProducts)-1]
		this.prefixProducts = append(this.prefixProducts, lastProduct*num)
	}
}

func (this *ProductOfNumbers) GetProduct(k int) int {
	if k > this.size {
		return 0
	}
	
	// Check if there's a zero in the last k elements
	if len(this.zeroIndices) > 0 {
		lastZeroIndex := this.zeroIndices[len(this.zeroIndices)-1]
		if this.size-lastZeroIndex < k {
			return 0
		}
	}
	
	// Return the product of the last k elements
	currentProduct := this.prefixProducts[len(this.prefixProducts)-1]
	kStepsBackProduct := this.prefixProducts[len(this.prefixProducts)-1-k]
	
	return currentProduct / kStepsBackProduct
}

/**
 * Your ProductOfNumbers object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Add(num);
 * param_2 := obj.GetProduct(k);
 */
```

## Link

[LeetCode 1352 Product of the Last K Numbers](https://leetcode.com/problems/product-of-the-last-k-numbers/)