# 2013 Detect Squares

## Problem Description

You are given a stream of points on the 2D plane. Design an algorithm to detect if there exists a square of size 2 that contains at least 2 of the points.

Implement the `DetectSquares` class:

- `DetectSquares()` Initializes the object with an empty points list.
- `void add(int[] point)` Adds a point to the points list.
- `int count(string axis, int[] val)` Returns the number of points that satisfy the condition based on the given axis and values.

The condition is:
- If axis is "x", count points where the x-coordinate is in the given values.
- If axis is "y", count points where the y-coordinate is in the given values.

### Example 1:
```
Input
["DetectSquares","add","add","add","add","add","count","count","count","count"]
[[],[[3,10]],[11,2],[3,8],[8,11],[14,12]],["x",[3,11]],[["y"],[11,2]],[["x"],[11,12]]]
Output
[null,null,null,null,null,null,1,1,0,1]

Explanation
DetectSquares detectSquares = new DetectSquares();
detectSquares.add([3, 10]);
detectSquares.add([11, 2]);
detectSquares.add([3, 8]);
detectSquares.add([8, 11]);
detectSquares.add([14, 12]);
detectSquares.count("x", [3, 11]); // return 1, point [3, 10] has x-coordinate 3
detectSquares.count("y", [11, 2]);  // return 1, point [11, 2] has y-coordinate 2
detectSquares.count("x", [11, 12]); // return 0, no point has x-coordinate 11 or 12
```

## The Twist

Implementing a point detection system that efficiently tracks points and can quickly count points with coordinates matching given values on a specific axis.

## Algorithm

### HashMap + Counter Approach:
1. Use two HashMaps to track x and y coordinates separately
2. Use two Counters to track occurrences of each coordinate value
3. For DetectSquares():
   - Initialize empty data structures
4. For add(point):
   - Increment the count for the x-coordinate
   - Increment the count for the y-coordinate
5. For count(axis, val):
   - If axis is "x", sum the counts for all values in val
   - If axis is "y", sum the counts for all values in val
   - Return the total

The key insight is using separate HashMaps and Counters for x and y coordinates to efficiently count matching points.

## Complexity

- **Time**: 
  - DetectSquares constructor: O(1)
  - add: O(1)
  - count: O(k) where k is the length of val array
- **Space**: O(n) where n is the number of points

## Solution Code

```go
package main

type DetectSquares struct {
	xCount map[int]int
	yCount map[int]int
}

func Constructor() DetectSquares {
	return DetectSquares{
		xCount: make(map[int]int),
		yCount: make(map[int]int),
	}
}

func (this *DetectSquares) Add(point []int)  {
	x, y := point[0], point[1]
	this.xCount[x]++
	this.yCount[y]++
}

func (this *DetectSquares) Count(axis string, val []int) int {
	count := 0
	
	if axis == "x" {
		for _, x := range val {
			count += this.xCount[x]
		}
	} else if axis == "y" {
		for _, y := range val {
			count += this.yCount[y]
		}
	}
	
	return count
}

/**
 * Your DetectSquares object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Add(point);
 * param_2 := obj.Count(axis,val);
 */
```

## Link

[LeetCode 2013 Detect Squares](https://leetcode.com/problems/detect-squares/)