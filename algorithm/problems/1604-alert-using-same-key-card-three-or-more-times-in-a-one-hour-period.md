# 1604 Alert Using Same Key-Card Three or More Times in a One Hour Period

## Problem Description

LeetCode company workers use key-cards to unlock office doors. Each time a worker uses their key-card, the security system saves the worker's name and the time when it was used. The system emits an alert if any worker uses the key-card three or more times in a one-hour period.

You are given a list of strings `keyName` and `keyTime` where `keyName[i]` and `keyTime[i]` represent the name and time of the i-th key-card usage, respectively.

Return a list of unique worker names who received an alert. The names can be returned in any order.

### Example 1:
```
Input: keyName = ["daniel","daniel","daniel","luis","luis","luis","luis"], 
       keyTime = ["10:00","10:40","11:00","20:00","21:00","22:00","23:00"]
Output: ["daniel"]
Explanation: "daniel" used the key-card 3 times in a one-hour period ("10:00","10:40","11:00").
```

### Example 2:
```
Input: keyName = ["alice","alice","alice","bob","bob","bob","bob"], 
       keyTime = ["12:01","12:03","12:05","12:02","12:04","12:06","12:08"]
Output: ["bob"]
Explanation: "bob" used the key-card 3 times in a one-hour period ("12:02","12:06","12:08").
```

## Approach

This problem can be solved using a sliding window approach:

1. First, group the access times by worker name.
2. For each worker, sort their access times in chronological order.
3. For each worker, use a sliding window to check if there are three or more accesses within a one-hour period.
4. If a worker has such accesses, add them to the alert list.

## Solution Code

```go
func alertNames(keyName []string, keyTime []string) []string {
    // Group access times by worker name
    workerAccess := make(map[string][]string)
    
    for i := 0; i < len(keyName); i++ {
        name := keyName[i]
        time := keyTime[i]
        workerAccess[name] = append(workerAccess[name], time)
    }
    
    var alertWorkers []string
    
    // Check each worker
    for name, times := range workerAccess {
        // Sort times in chronological order
        sort.Strings(times)
        
        // Check for three or more accesses within one hour
        for i := 2; i < len(times); i++ {
            time1 := parseTime(times[i-2])
            time3 := parseTime(times[i])
            
            // If the time difference is less than 60 minutes, add to alert list
            if time3-time1 <= 60 {
                alertWorkers = append(alertWorkers, name)
                break
            }
        }
    }
    
    return alertWorkers
}

// Helper function to parse time string to minutes since midnight
func parseTime(timeStr string) int {
    parts := strings.Split(timeStr, ":")
    hour, _ := strconv.Atoi(parts[0])
    minute, _ := strconv.Atoi(parts[1])
    return hour*60 + minute
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting the access times for each worker dominates the time complexity
- **Space**: O(n) - We store the access times for each worker

## Link

[LeetCode 1604 Alert Using Same Key-Card Three or More Times in a One Hour Period](https://leetcode.com/problems/alert-using-same-key-card-three-or-more-times-in-a-one-hour-period/)