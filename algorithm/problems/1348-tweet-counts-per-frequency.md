# 1348 Tweet Counts Per Frequency

## Problem Description

A social media platform implements a feature that tracks how many tweets a user has posted within the past 24 hours. The platform records each tweet with a timestamp.

Implement the `TweetCounts` class that supports the following methods:

1. `recordTweet(string tweetName, int time)` - Records a tweet with the given tweetName at the given time.
2. `getTweetCountsPerFrequency(string freq, int startTime, int endTime)` - Returns the total number of tweets for each tweetName recorded between the startTime and endTime (inclusive), grouped by the specified frequency.

The frequency can be:
- "minute" - groups tweets by 60-second intervals
- "hour" - groups tweets by 3600-second intervals
- "day" - groups tweets by 86400-second intervals

### Example 1:
```
Input
["TweetCounts","recordTweet","recordTweet","recordTweet","getTweetCountsPerFrequency","getTweetCountsPerFrequency","getTweetCountsPerFrequency","recordTweet","getTweetCountsPerFrequency"]
[[],["tweet3",0],["tweet3",60],["tweet3",10],["minute",0,59],["minute",0,60],["hour",0,60],["tweet3",120],["hour",0,210]]

Output
[null,null,null,null,[2,2,1],[2,1,1],null,null,[4]]

Explanation:
TweetCounts tweetCounts = new TweetCounts();
tweetCounts.recordTweet("tweet3", 0);
tweetCounts.recordTweet("tweet3", 60);
tweetCounts.recordTweet("tweet3", 10);                             // All tweets correspond to "tweet3" with recorded times at 0, 10 and 60.
tweetCounts.getTweetCountsPerFrequency("minute", 0, 59);              // return [2]. The frequency is per minute (60 seconds), so there is one interval of time: 0 <= t < 60. There are 2 tweets in this interval.
tweetCounts.getTweetCountsPerFrequency("minute", 0, 60);              // return [2, 1]. The frequency is per minute (60 seconds), so there are two intervals of time: 0 <= t < 60 and 60 <= t <= 120. There are 2 tweets in the first interval and 1 tweet in the second interval.
tweetCounts.getTweetCountsPerFrequency("hour", 0, 60);               // return [1]. The frequency is per hour (3600 seconds), so there is one interval of time: 0 <= t <= 60. There is 1 tweet in this interval.
tweetCounts.recordTweet("tweet3", 120);                            // All tweets correspond to "tweet3" with recorded times at 0, 10, 60 and 120.
tweetCounts.getTweetCountsPerFrequency("hour", 0, 210);              // return [4]. The frequency is per hour (3600 seconds), so there is one interval of time: 0 <= t <= 210. There are 4 tweets in this interval.
```

## The Twist

Implementing a tweet tracking system that efficiently records tweets and retrieves counts grouped by different time frequencies.

## Algorithm

### HashMap + Binary Search Approach:
1. Use a HashMap to store tweet timestamps for each tweetName
2. For recordTweet(tweetName, time):
   - Add the timestamp to the list for tweetName in the HashMap
3. For getTweetCountsPerFrequency(freq, startTime, endTime):
   - Determine the interval size based on frequency (60 for minute, 3600 for hour, 86400 for day)
   - For each tweetName:
     - Get the list of timestamps for this tweetName
     - Sort the timestamps (if not already sorted)
     - Use binary search to find the first timestamp >= startTime
     - Iterate through timestamps until > endTime, counting tweets in each interval
     - Add the counts to the result

The key insight is storing timestamps for each tweet and using binary search to efficiently count tweets within specified intervals.

## Complexity

- **Time**: 
  - recordTweet: O(1) for adding, O(logn) if maintaining sorted order
  - getTweetCountsPerFrequency: O(nlogn) where n is the number of tweets for the given tweetName
- **Space**: O(n) where n is the total number of tweets recorded

## Solution Code

```go
package main

import (
	"sort"
)

type TweetCounts struct {
	tweets map[string][]int
}

func Constructor() TweetCounts {
	return TweetCounts{
		tweets: make(map[string][]int),
	}
}

func (this *TweetCounts) RecordTweet(tweetName string, time int)  {
	this.tweets[tweetName] = append(this.tweets[tweetName], time)
}

func (this *TweetCounts) GetTweetCountsPerFrequency(freq string, startTime int, endTime int) []int {
	// Determine interval size based on frequency
	var interval int
	switch freq {
	case "minute":
		interval = 60
	case "hour":
		interval = 3600
	case "day":
		interval = 86400
	}
	
	// Calculate number of intervals
	numIntervals := (endTime - startTime + interval) / interval
	result := make([]int, numIntervals)
	
	// For each tweet name, count tweets in each interval
	for tweetName, times := range this.tweets {
		// Sort the timestamps for this tweet
		sort.Ints(times)
		
		// For each interval, count tweets
		for i := 0; i < numIntervals; i++ {
			intervalStart := startTime + i*interval
			intervalEnd := intervalStart + interval - 1
			if intervalEnd > endTime {
				intervalEnd = endTime
			}
			
			// Use binary search to find the first tweet >= intervalStart
			left := sort.SearchInts(times, intervalStart)
			
			// Use binary search to find the first tweet > intervalEnd
			right := sort.SearchInts(times, intervalEnd+1)
			
			// Add the count to the result
			result[i] += right - left
		}
	}
	
	return result
}

/**
 * Your TweetCounts object will be instantiated and called as such:
 * obj := Constructor();
 * obj.RecordTweet(tweetName,time);
 * param_2 := obj.GetTweetCountsPerFrequency(freq,startTime,endTime);
 */
```

## Link

[LeetCode 1348 Tweet Counts Per Frequency](https://leetcode.com/problems/tweet-counts-per-frequency/)