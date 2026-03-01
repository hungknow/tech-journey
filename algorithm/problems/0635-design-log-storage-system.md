# 0635 Design Log Storage System

## Problem Description

You are given several logs, where each log contains a unique identifier and a timestamp. The timestamp is formatted as `YYYY:MM:DD:hh:mm:ss`. Design a log storage system to implement the following functions:

```
LogSystem()
```

Initializes the system.

```
void put(int id, String timestamp)
```

Stores the log with the given `id` and `timestamp`.

```
List<Integer> retrieve(String start, String end, String granularity)
```

Returns all logs whose timestamps are within the range from `start` to `end` inclusive. The `granularity` parameter specifies the level of precision for the timestamp comparison, which can be `"Year"`, `"Month"`, `"Day"`, `"Hour"`, `"Minute"`, or `"Second"`.

### Example 1:
```
Input
["LogSystem", "put", "put", "put", "retrieve", "retrieve"]
[[], [1, "2017:01:01:23:59:59"], [2, "2017:01:01:22:59:59"], [3, "2016:01:01:00:00:00"], ["2016:01:01:01:01:01", "2017:01:01:23:00:00", "Year"], ["2016:01:01:01:01:01", "2017:01:01:23:00:00", "Hour"]]

Output
[null, null, null, null, [3], [2, 3]]

Explanation
LogSystem logSystem = new LogSystem();
logSystem.put(1, "2017:01:01:23:59:59");
logSystem.put(2, "2017:01:01:22:59:59");
logSystem.put(3, "2016:01:01:00:00:00");
logSystem.retrieve("2016:01:01:01:01:01", "2017:01:01:23:00:00", "Year");  // return [3], since only log 3 is in the range 2016:01:01:00:00:00 to 2017:01:01:23:00:00
logSystem.retrieve("2016:01:01:01:01:01", "2017:01:01:23:00:00", "Hour"); // return [2, 3]
```

## The Twist

Implementing a log storage system that efficiently stores logs and retrieves them based on time ranges with different granularities.

## Algorithm

### HashMap + Timestamp Truncation Approach:
1. Use a HashMap to store the mapping from log ID to timestamp
2. Create a mapping from granularity to the index where to truncate the timestamp
3. For put(id, timestamp):
   - Store the timestamp in the HashMap with the ID as key
4. For retrieve(start, end, granularity):
   - Truncate both start and end timestamps based on the granularity
   - For each log in the HashMap:
     - Truncate the log's timestamp to the same granularity
     - If the truncated timestamp is between start and end (inclusive), add the ID to the result
   - Return the list of matching IDs

The key insight is truncating timestamps to the specified granularity and then performing simple string comparisons.

## Complexity

- **Time**: 
  - put: O(1)
  - retrieve: O(n + dlogd) where n is the number of logs and d is the number of digits in the timestamp
- **Space**: O(n) where n is the number of logs

## Solution Code

```go
package main

import (
	"strings"
)

type LogSystem struct {
	logs map[int]string
}

func Constructor() LogSystem {
	return LogSystem{
		logs: make(map[int]string),
	}
}

func (this *LogSystem) Put(id int, timestamp string)  {
	this.logs[id] = timestamp
}

func (this *LogSystem) Retrieve(start string, end string, granularity string) []int {
	granularityMap := map[string]int{
		"Year":   4,
		"Month":  7,
		"Day":    10,
		"Hour":   13,
		"Minute": 16,
		"Second": 19,
	}
	
	granIdx := granularityMap[granularity]
	startTruncated := start[:granIdx]
	endTruncated := end[:granIdx]
	
	result := make([]int, 0)
	for id, timestamp := range this.logs {
		timestampTruncated := timestamp[:granIdx]
		if timestampTruncated >= startTruncated && timestampTruncated <= endTruncated {
			result = append(result, id)
		}
	}
	
	return result
}

/**
 * Your LogSystem object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Put(id,timestamp);
 * param_2 := obj.Retrieve(start,end,granularity);
 */
```

## Link

[LeetCode 0635 Design Log Storage System](https://leetcode.com/problems/design-log-storage-system/)