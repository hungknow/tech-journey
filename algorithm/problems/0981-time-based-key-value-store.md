# 0981 Time Based Key-Value Store

## Problem Description

Design a time-based key-value store that supports two operations:

1. `set(String key, String value, int timestamp)`: Stores or updates the key with the given value at the given timestamp.
2. `get(String key, int timestamp)`: Returns the value associated with the key as of the given timestamp. If there are multiple values for the same timestamp, return the one with the greatest value.

If there is no value for the given timestamp, return `""`.

### Example 1:
```
Input:
["TimeMap","set","foo","bar"], 1, "foo"]
["TimeMap","set","foo","bar2"], 4, "foo"]
["TimeMap","set","foo","bar2"], 4, "foo2"]
["TimeMap","get","foo", 3]
["TimeMap","get","bar", 3]
Output: "foo"
Explanation: At timestamp 3, there are two values "foo" and "foo2". "foo" is returned as it has the greater value.
```

## The Twist

Implementing a **time-based key-value store** with efficient retrieval. The key insight is to use a TreeMap or similar structure to maintain entries sorted by timestamp.

## Algorithm

### TreeMap Approach:
1. Use a TreeMap (or balanced BST) to store entries sorted by timestamp
2. For `set` operation:
   - Insert the new entry with the given timestamp
3. For `get` operation:
   - Use binary search to find the greatest timestamp ≤ query timestamp
   - Return the value at that timestamp

## Complexity

- **Time**: 
  - `set`: O(log n) - insertion in TreeMap
  - `get`: O(log n) - binary search in TreeMap
- **Space**: O(n) - storing all entries

## Solution Code

```go
package main

import (
	"sort"
	"strings"
)

type TimeMap struct {
	entries []Entry
}

type Entry struct {
	timestamp int
	value     string
}

func Constructor() TimeMap {
	return TimeMap{
		entries: []Entry{},
	}
}

func (tm *TimeMap) set(key string, value string, timestamp int) {
	entry := Entry{
		timestamp: timestamp,
		value:     value,
	}
	
	// Insert while maintaining sorted order by timestamp
	i := len(tm.entries) - 1
	for i >= 0 && tm.entries[i].timestamp > timestamp {
		tm.entries[i+1] = tm.entries[i]
		i--
	}
	
	tm.entries[i+1] = entry
}

func (tm *TimeMap) get(key string, timestamp int) string {
	// Binary search for the greatest timestamp ≤ query
	left, right := 0, len(tm.entries)-1
	result := ""
	
	for left <= right {
		mid := left + (right-left)/2
		
		if tm.entries[mid].timestamp <= timestamp {
			if tm.entries[mid].value == key && tm.entries[mid].timestamp > result {
				result = tm.entries[mid].value
			}
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return result
}
```

## Link

[LeetCode 0981 Time Based Key-Value Store](https://leetcode.com/problems/time-based-key-value-store/)
