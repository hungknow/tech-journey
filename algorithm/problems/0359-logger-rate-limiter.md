# 0359 Logger Rate Limiter

## Problem Description

Design a logger system that receives a stream of messages along with their timestamps. Each message should only be printed if it has not been printed in the last 10 seconds.

Implement the `Logger` class:

- `Logger()` Initializes the logger object.
- `bool shouldPrintMessage(int timestamp, string message)` Returns `true` if the message should be printed in the given timestamp, otherwise returns `false`.

### Example 1:
```
Input
["Logger", "shouldPrintMessage", "shouldPrintMessage", "shouldPrintMessage", "shouldPrintMessage", "shouldPrintMessage", "shouldPrintMessage"]
[[], [1, "foo"], [2, "bar"], [3, "foo"], [8, "bar"], [10, "foo"], [11, "foo"]]
Output
[null, true, true, false, false, false, true]

Explanation
Logger logger = new Logger();
logger.shouldPrintMessage(1, "foo");  // return true, next allowed timestamp for "foo" is 1 + 10
logger.shouldPrintMessage(2, "bar");  // return true, next allowed timestamp for "bar" is 2 + 10
logger.shouldPrintMessage(3, "foo");  // 3 < 1 + 10, return false
logger.shouldPrintMessage(8, "bar");  // 8 < 2 + 10, return false
logger.shouldPrintMessage(10, "foo"); // 10 >= 1 + 10, return true
logger.shouldPrintMessage(11, "foo"); // 11 >= 1 + 10, return true
```

## The Twist

Implementing an efficient rate limiter that can handle a stream of messages with O(1) average time complexity per operation.

## Algorithm

### Hash Map Approach:
1. Use a hash map to store the last timestamp when each message was printed
2. For each incoming message:
   - Check if the message exists in the map
   - If it doesn't exist, or if current timestamp >= last timestamp + 10:
     - Update the map with current timestamp
     - Return true (should print)
   - Otherwise:
     - Return false (should not print)
3. The key insight is that we only need to store the last timestamp for each message

## Complexity

- **Time**: O(1) average time for shouldPrintMessage operation
- **Space**: O(n) where n is the number of unique messages

## Solution Code

```go
package main

type Logger struct {
    messageTimestamps map[string]int
}

func Constructor() Logger {
    return Logger{
        messageTimestamps: make(map[string]int),
    }
}

func (this *Logger) ShouldPrintMessage(timestamp int, message string) bool {
    if lastTimestamp, ok := this.messageTimestamps[message]; !ok || timestamp >= lastTimestamp+10 {
        this.messageTimestamps[message] = timestamp
        return true
    }
    return false
}
```

## Link

[LeetCode 0359 Logger Rate Limiter](https://leetcode.com/problems/logger-rate-limiter/)