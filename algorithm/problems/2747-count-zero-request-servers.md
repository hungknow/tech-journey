# 2747 Count Zero Request Servers

## Problem Description

You are given an integer array `logs` where `logs[i] = [server_id, request_time]`.

A server is considered zero request if it has received no requests for a continuous period of time.

Return the number of zero request servers.

### Example 1:
```
Input: logs = [[1,3],[2,1],[3,5],[4,2],[5,4]]
Output: 2
Explanation: Server 1 received requests at times 3 and 1, so it's not zero request.
Server 2 received a request at time 1, so it's not zero request.
Server 3 received a request at time 5, so it's not zero request.
Server 4 received a request at time 2, so it's not zero request.
Server 5 received a request at time 4, so it's not zero request.
No server is zero request.
```

### Example 2:
```
Input: logs = [[1,2],[2,1],[3,2],[4,3],[5,4]]
Output: 1
Explanation: Server 1 received requests at times 2 and 1, so it's not zero request.
Server 2 received a request at time 1, so it's not zero request.
Server 3 received a request at time 2, so it's not zero request.
Server 4 received a request at time 3, so it's not zero request.
Server 5 received a request at time 4, so it's not zero request.
No server is zero request.
```

## Approach

This problem can be solved using a two-pointer approach:

1. First, sort the logs by server ID and then by request time.
2. For each server, check if it has received any requests.
3. If a server has received no requests, increment the count.
4. Use two pointers to efficiently traverse the sorted logs.

## Solution Code

```go
func countZeroRequestServers(logs [][]int) int {
    // Sort logs by server ID, then by request time
    sort.Slice(logs, func(i, j int) bool {
        if logs[i][0] == logs[j][0] {
            return logs[i][1] < logs[j][1]
        }
        return logs[i][0] < logs[j][0]
    })
    
    count := 0
    i := 0
    n := len(logs)
    
    for i < n {
        serverID := logs[i][0]
        
        // Check if this server has received any requests
        if i > 0 && logs[i][0] == logs[i-1][0] {
            // Same server as previous, skip
            i++
            continue
        }
        
        // Check if this is the last log for this server
        if i == n-1 || logs[i+1][0] != serverID {
            // No more logs for this server
            if logs[i][1] > 0 {
                // Server has received requests
                count++
            }
            i++
        } else {
            // More logs for this server
            i++
        }
    }
    
    return count
}
```

## Complexity Analysis

- **Time**: O(n log n) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 2747 Count Zero Request Servers](https://leetcode.com/problems/count-zero-request-servers/)