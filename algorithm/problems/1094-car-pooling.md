# 1094 Car Pooling

## Problem Description

There is a car with capacity `emptySeats` seats. The vehicle only drives east (i.e., it cannot turn around and drive west).

You are given the integer `capacity` and an array `trips` where `trips[i] = [numPassengers, startLocation, endLocation]` indicates that the ith trip has `numPassengers` passengers and the locations to pick them up and drop them off are `startLocation` and `endLocation` respectively.

The locations are given as the number of kilometers due east from the car's initial location.

Return `true` if it is possible to pick up and drop off all passengers for all the given trips, or `false` otherwise.

### Example 1:
```
Input: trips = [[2,1,5],[3,3,7]], capacity = 4
Output: false
```

### Example 2:
```
Input: trips = [[2,1,5],[3,3,7]], capacity = 5
Output: true
```

## Solution Approach

This is a variant of the Meeting Rooms II problem. We need to track the number of passengers in the car at each location and ensure it never exceeds the capacity.

## Algorithm

1. Create a list of all passenger changes:
   - For each trip [numPassengers, start, end], add (start, numPassengers) and (end, -numPassengers) to the list.
2. Sort this list by location.
3. Initialize `currentPassengers` = 0.
4. Iterate through the sorted list:
   - Add the passenger change to `currentPassengers`.
   - If `currentPassengers` exceeds `capacity`, return false.
5. If we complete the iteration without exceeding capacity, return true.

## Alternative Algorithm (Using Array)

If the locations are within a reasonable range:
1. Create an array to track passenger changes at each location.
2. For each trip, add passengers at the start location and subtract at the end location.
3. Iterate through the array, maintaining a running total of passengers.
4. Check if the total ever exceeds capacity.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n + m) for array approach where m is the range of locations
- **Space**: O(n) for sorting approach, O(m) for array approach

## Link

[LeetCode 1094 Car Pooling](https://leetcode.com/problems/car-pooling/)