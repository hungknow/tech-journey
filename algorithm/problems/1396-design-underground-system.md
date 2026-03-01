# 1396 Design Underground System

## Problem Description

Implement the `UndergroundSystem` class. It supports two methods:

1. `void checkIn(int id, string stationName, int t)`
   - A customer with a card id equal to `id`, checks in at the station `stationName` at time `t`.
   - A customer can only be checked into one place at a time.
2. `void checkOut(int id, string stationName, int t)`
   - A customer with a card id equal to `id`, checks out from the station `stationName` at time `t`.
3. `double getAverageTime(string startStation, string endStation)`
   - Returns the average time it takes to travel from `startStation` to `endStation`.
   - The average time is computed from all the previous traveling times from `startStation` to `endStation` that happened directly.
   - Call to `getAverageTime` is always valid.

You can assume all calls to the `checkIn` and `checkOut` methods are consistent. If a customer checks in at time `t1` then checks out at time `t2`, then `t1 < t2`. All events happen in chronological order.

### Example 1:
```
Input
["UndergroundSystem","checkIn","checkIn","checkOut","checkOut","getAverageTime","getAverageTime","checkIn","getAverageTime"]
[[],[45,"Leyton",10],[32,"Paradise",24],[45,"Waterloo",30],[32,"Cambridge",40],["Leyton","Waterloo"],["Paradise","Cambridge"],[10,"Leyton",20],["Leyton","Waterloo"]]

Output
[null,null,null,null,null,14.0,11.0,null,12.0]

Explanation
UndergroundSystem undergroundSystem = new UndergroundSystem();
undergroundSystem.checkIn(45, "Leyton", 10);
undergroundSystem.checkIn(32, "Paradise", 24);
undergroundSystem.checkOut(45, "Waterloo", 30);
undergroundSystem.checkOut(32, "Cambridge", 40);
undergroundSystem.getAverageTime("Leyton", "Waterloo");       // return 14.0. There was only one travel from "Leyton" to "Waterloo", 30 - 10 = 20
undergroundSystem.getAverageTime("Paradise", "Cambridge"); // return 11.0. There was only one travel from "Paradise" to "Cambridge", 40 - 24 = 16
undergroundSystem.checkIn(10, "Leyton", 20);
undergroundSystem.getAverageTime("Leyton", "Waterloo");       // return 12.0. There were two travels from "Leyton" to "Waterloo", (30 - 10) + (20 - 20) = 20 + 0 = 20, 20 / 2 = 10
```

## The Twist

Implementing an underground system that efficiently tracks check-ins and check-outs to calculate average travel times between stations.

## Algorithm

### HashMap Pair Approach:
1. Use a HashMap to track active check-ins (id -> (station, time))
2. Use another HashMap to track travel statistics (startStation -> endStation -> (totalTime, count))
3. For checkIn(id, stationName, t):
   - Store the check-in information for the customer
4. For checkOut(id, stationName, t):
   - Retrieve the check-in information for the customer
   - Calculate the travel time
   - Update the travel statistics for this route
   - Remove the customer from active check-ins
5. For getAverageTime(startStation, endStation):
   - Retrieve the travel statistics for this route
   - Return totalTime / count

The key insight is using nested HashMaps to efficiently track and retrieve travel statistics between station pairs.

## Complexity

- **Time**: 
  - UndergroundSystem constructor: O(1)
  - checkIn: O(1)
  - checkOut: O(1)
  - getAverageTime: O(1)
- **Space**: O(n) where n is the number of active check-ins plus the number of unique routes

## Solution Code

```go
package main

type CheckIn struct {
	station string
	time    int
}

type TravelStats struct {
	totalTime int
	count    int
}

type UndergroundSystem struct {
	checkIns map[int]CheckIn
	travelStats map[string]map[string]TravelStats
}

func Constructor() UndergroundSystem {
	return UndergroundSystem{
		checkIns: make(map[int]CheckIn),
		travelStats: make(map[string]map[string]TravelStats),
	}
}

func (this *UndergroundSystem) CheckIn(id int, stationName string, t int)  {
	this.checkIns[id] = CheckIn{
		station: stationName,
		time:    t,
	}
}

func (this *UndergroundSystem) CheckOut(id int, stationName string, t int)  {
	checkIn := this.checkIns[id]
	
	// Calculate travel time
	travelTime := t - checkIn.time
	
	// Update travel statistics
	if _, exists := this.travelStats[checkIn.station]; !exists {
		this.travelStats[checkIn.station] = make(map[string]TravelStats)
	}
	
	stats := this.travelStats[checkIn.station][stationName]
	stats.totalTime += travelTime
	stats.count++
	this.travelStats[checkIn.station][stationName] = stats
	
	// Remove check-in
	delete(this.checkIns, id)
}

func (this *UndergroundSystem) GetAverageTime(startStation string, endStation string) float64 {
	stats := this.travelStats[startStation][endStation]
	return float64(stats.totalTime) / float64(stats.count)
}

/**
 * Your UndergroundSystem object will be instantiated and called as such:
 * obj := Constructor();
 * obj.CheckIn(id,stationName,t);
 * obj.CheckOut(id,stationName,t);
 * param_3 := obj.GetAverageTime(startStation,endStation);
 */
```

## Link

[LeetCode 1396 Design Underground System](https://leetcode.com/problems/design-underground-system/)