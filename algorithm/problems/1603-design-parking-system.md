# 1603 Design Parking System

## Problem Description

Design a parking system for a parking lot. The parking lot has three kinds of parking spaces: big, medium, and small, which are represented by 1, 2, and 3 respectively.

Implement the `ParkingSystem` class:

- `ParkingSystem(int big, int medium, int small)` Initializes the object with the number of slots for each parking space type.
- `bool addCar(int carType)` Checks whether there is a parking slot of the given carType in the parking lot. If there is, the car parks in that slot and returns true, otherwise returns false.

### Example 1:
```
Input
["ParkingSystem","addCar","addCar","addCar","addCar"]
[[1,1,0],[1],[2],[3],[1]]
Output
[null,true,true,false,false]

Explanation
ParkingSystem parkingSystem = new ParkingSystem(1, 1, 0);
parkingSystem.addCar(1); // return true because there is 1 available slot for a big car
parkingSystem.addCar(2); // return true because there is 1 available slot for a medium car
parkingSystem.addCar(3); // return false because there is no available slot for a small car
parkingSystem.addCar(1); // return false because there is no available slot for a big car
```

## The Twist

Implementing a parking system that efficiently tracks available slots for different car types and allocates them appropriately.

## Algorithm

### Counter Approach:
1. Use counters to track the number of available slots for each car type
2. For ParkingSystem(big, medium, small):
   - Initialize the counters with the given values
3. For addCar(carType):
   - Check if there's an available slot for the given car type
   - If yes, decrement the counter and return true
   - If no, return false

The key insight is using simple counters to track available slots for each car type, making the implementation straightforward and efficient.

## Complexity

- **Time**: 
  - ParkingSystem constructor: O(1)
  - addCar: O(1)
- **Space**: O(1)

## Solution Code

```go
package main

type ParkingSystem struct {
	big    int
	medium int
	small  int
}

func Constructor(big int, medium int, small int) ParkingSystem {
	return ParkingSystem{
		big:    big,
		medium: medium,
		small:  small,
	}
}

func (this *ParkingSystem) AddCar(carType int) bool {
	switch carType {
	case 1: // Big car
		if this.big > 0 {
			this.big--
			return true
		}
	case 2: // Medium car
		if this.medium > 0 {
			this.medium--
			return true
		}
	case 3: // Small car
		if this.small > 0 {
			this.small--
			return true
		}
	}
	
	return false
}

/**
 * Your ParkingSystem object will be instantiated and called as such:
 * obj := Constructor(big, medium, small);
 * param_1 := obj.AddCar(carType);
 */
```

## Link

[LeetCode 1603 Design Parking System](https://leetcode.com/problems/design-parking-system/)