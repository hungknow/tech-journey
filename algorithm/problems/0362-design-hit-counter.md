# 0362 Design Hit Counter

## Problem Description

Design a hit counter which counts the number of hits received in the past 5 minutes (i.e., the last 300 seconds).

Your system should track hits at timestamps and return the number of hits in the last 5 minutes.

Implement the `HitCounter` class:

- `HitCounter()` Initializes the object of the hit counter system.
- `void hit(int timestamp)` Records a hit that happened at timestamp (in seconds). Several hits may happen at the same timestamp.
- `int getHits(int timestamp)` Returns the number of hits in the past 5 minutes from timestamp (i.e., the last 300 seconds).

### Example 1:
```
Input
["HitCounter", "hit", "hit", "hit", "getHits", "hit", "getHits", "getHits"]
[[], [1], [2], [3], [4], [300], [300], [301]]
Output
[null, null, null, null, 3, null, 3, 4]

Explanation
HitCounter hitCounter = new HitCounter();
hitCounter.hit(1);       // hit at timestamp 1.
hitCounter.hit(2);       // hit at timestamp 2.
hitCounter.hit(3);       // hit at timestamp 3.
hitCounter.getHits(4);   // get hits at timestamp 4, return 3.
hitCounter.hit(300);     // hit at timestamp 300.
hitCounter.getHits(300); // get hits at timestamp 300, return 3.
hitCounter.getHits(301); // get hits at timestamp 301, return 4.
```

## The Twist

Implementing an efficient hit counter that can handle a stream of hits and quickly calculate hits within a sliding time window.

## Algorithm

### Queue Approach:
1. Use a queue to store timestamps of hits
2. For each hit(timestamp):
   - Add the timestamp to the queue
3. For getHits(timestamp):
   - Remove all timestamps from the front of the queue that are older than timestamp - 300
   - Return the size of the queue (number of hits in the last 300 seconds)

The key insight is that we only need to store recent hits and can efficiently remove old ones using the queue's FIFO property.

## Complexity

- **Time**: 
  - hit: O(1) - just add to queue
  - getHits: O(k) where k is the number of old hits to remove, amortized O(1)
- **Space**: O(n) where n is the number of hits in the last 300 seconds

## Solution Code

```go
package main

type HitCounter struct {
    timestamps []int
}

func Constructor() HitCounter {
    return HitCounter{
        timestamps: make([]int, 0),
    }
}

func (this *HitCounter) Hit(timestamp int) {
    this.timestamps = append(this.timestamps, timestamp)
}

func (this *HitCounter) GetHits(timestamp int) int {
    // Remove hits that are older than 300 seconds
    for len(this.timestamps) > 0 && this.timestamps[0] <= timestamp-300 {
        this.timestamps = this.timestamps[1:]
    }
    
    return len(this.timestamps)
}
```

## Link

[LeetCode 0362 Design Hit Counter](https://leetcode.com/problems/design-hit-counter/)