# 2933 High-Access Employees

## Problem Description

You are given two arrays `access_times` and `access_times[i] = [employee_id, access_time]`.

An employee is considered high-access if they have accessed the system more than `k` times in a 24-hour period.

Return the IDs of the high-access employees.

### Example 1:
```
Access times: [[1,3],[2,4],[3,5],[4,6],[5,7]]
k = 2
Output: [0,2,3]
Explanation: Employee 0 accessed the system at times 3 and 3 (2 times, within 24 hours).
Employee 2 accessed the system at time 4 (1 time, within 24 hours).
Employee 3 accessed the system at time 5 (1 time, within 24 hours).
Employee 4 accessed the system at time 6 (1 time, within 24 hours).
Employee 5 accessed the system at time 7 (1 time, within 24 hours).
```

### Example 2:
```
Access times: [[1,3],[2,4],[3,5],[4,6],[5,7]]
k = 1
Output: [0,1,2,3,4,5]
Explanation: All employees accessed the system more than once within 24 hours.
```

## Approach

This problem can be solved using a sliding window approach:

1. Sort the access times by employee ID and then by access time.
2. Use a sliding window to count the number of accesses within a 24-hour period.
3. For each employee, if the count is greater than `k`, add their ID to the result.
4. Return the sorted list of employee IDs.

## Solution Code

```go
func findHighAccessEmployees(access_times [][]int, k int) []int {
    // Sort by employee ID, then by access time
    sort.Slice(access_times, func(i, j int) bool {
        if access_times[i][0] == access_times[j][0] {
            return access_times[i][1] < access_times[j][1]
        }
        return access_times[i][0] < access_times[j][0]
    })
    
    n := len(access_times)
    result := []int{}
    
    for i := 0; i < n; {
        employeeID := access_times[i][0]
        count := 0
        
        // Count accesses within 24 hours
        j := i
        for j < n && access_times[j][0] == employeeID && access_times[j][1] <= access_times[i][1]+24*3600 {
            count++
            j++
        }
        
        if count > k {
            result = append(result, employeeID)
        }
        
        // Skip to the next employee
        i = j
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n log n + n log n) - Sorting dominates the time complexity
- **Space**: O(n) - We store the result list

## Link

[LeetCode 2933 High-Access Employees](https://leetcode.com/problems/high-access-employees/)