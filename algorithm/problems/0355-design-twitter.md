# 0355 Design Twitter

## Problem Description

Design a simplified version of Twitter where users can post tweets, follow/unfollow another user, and see the 10 most recent tweets in the user's news feed.

Implement the `Twitter` class:

- `Twitter()` Initializes your twitter object.
- `void postTweet(int userId, int tweetId)` Composes a new tweet with ID `tweetId` by the user `userId`. Each call to this function will be made with a unique `tweetId`.
- `List<Integer> getNewsFeed(int userId)` Retrieves the 10 most recent tweet IDs in the user's news feed. Each item in the news feed must be posted by users who the user follows or by the user themself. Tweets must be ordered from most recent to least recent.
- `void follow(int followerId, int followeeId)` The user with ID `followerId` started following the user with ID `followeeId`.
- `void unfollow(int followerId, int followeeId)` The user with ID `followerId` started unfollowing the user with ID `followeeId`.

### Example 1:
```
Input
["Twitter", "postTweet", "getNewsFeed", "follow", "postTweet", "getNewsFeed", "unfollow", "getNewsFeed"]
[[], [1, 5], [1], [1, 2], [2, 6], [1], [1, 2], [1]]
Output
[null, null, [5], null, null, [6, 5], null, [5]]

Explanation
Twitter twitter = new Twitter();
twitter.postTweet(1, 5); // User 1 posts a new tweet (id = 5).
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 1 tweet id -> [5]. return [5]
twitter.follow(1, 2);    // User 1 follows user 2.
twitter.postTweet(2, 6); // User 2 posts a new tweet (id = 6).
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 2 tweet ids -> [6, 5]. tweetId 6 should precede tweetId 5 because it is posted after tweetId 5.
twitter.unfollow(1, 2);  // User 1 unfollows user 2.
twitter.getNewsFeed(1);  // User 1's news feed should return a list with 1 tweet id -> [5], since user 1 is no longer following user 2.
```

## The Twist

Implementing a Twitter-like system that efficiently generates news feeds by merging tweets from multiple users in chronological order.

## Algorithm

### HashMap + Max-Heap Approach:
1. Use a HashMap to store user relationships (who follows whom)
2. Use a HashMap to store tweets for each user
3. Use a timestamp to track tweet order
4. For postTweet(userId, tweetId):
   - Add tweet to user's tweet list with current timestamp
   - Increment timestamp
5. For getNewsFeed(userId):
   - Get all users that userId follows (including themselves)
   - Use a max-heap to get the most recent tweets from all followed users
   - Merge the tweet lists and return top 10
6. For follow/follow:
   - Update the following relationships in the HashMap

The key insight is using a max-heap to efficiently merge and find the most recent tweets from multiple sources.

## Complexity

- **Time**: 
  - postTweet: O(1)
  - getNewsFeed: O(u + k log u) where u is number of followed users and k=10
  - follow/unfollow: O(1)
- **Space**: O(t + f) where t is total tweets and f is total follow relationships

## Solution Code

```go
package main

import "container/heap"

type Tweet struct {
    id        int
    timestamp int
    next      *Tweet
}

type User struct {
    id     int
    head   *Tweet
    followed map[int]bool
}

type Twitter struct {
    users     map[int]*User
    timestamp int
}

func Constructor() Twitter {
    return Twitter{
        users:     make(map[int]*User),
        timestamp: 0,
    }
}

func (this *Twitter) PostTweet(userId int, tweetId int)  {
    if _, exists := this.users[userId]; !exists {
        this.users[userId] = &User{
            id:       userId,
            followed: make(map[int]bool),
        }
        this.users[userId].followed[userId] = true
    }
    
    user := this.users[userId]
    tweet := &Tweet{
        id:        tweetId,
        timestamp: this.timestamp,
        next:      user.head,
    }
    user.head = tweet
    this.timestamp++
}

func (this *Twitter) GetNewsFeed(userId int) []int {
    if _, exists := this.users[userId]; !exists {
        return []int{}
    }
    
    user := this.users[userId]
    followed := user.followed
    
    // Create a max-heap
    h := &MaxHeap{}
    heap.Init(h)
    
    // Add the head tweet of each followed user to the heap
    for followeeId := range followed {
        if followeeUser, exists := this.users[followeeId]; exists && followeeUser.head != nil {
            heap.Push(h, &TweetNode{
                tweet: followeeUser.head,
                user:  followeeUser,
            })
        }
    }
    
    // Extract up to 10 most recent tweets
    result := make([]int, 0)
    for h.Len() > 0 && len(result) < 10 {
        node := heap.Pop(h).(*TweetNode)
        result = append(result, node.tweet.id)
        
        // Add next tweet from the same user
        if node.tweet.next != nil {
            heap.Push(h, &TweetNode{
                tweet: node.tweet.next,
                user:  node.user,
            })
        }
    }
    
    return result
}

func (this *Twitter) Follow(followerId int, followeeId int)  {
    if _, exists := this.users[followerId]; !exists {
        this.users[followerId] = &User{
            id:       followerId,
            followed: make(map[int]bool),
        }
        this.users[followerId].followed[followerId] = true
    }
    
    if _, exists := this.users[followeeId]; !exists {
        this.users[followeeId] = &User{
            id:       followeeId,
            followed: make(map[int]bool),
        }
        this.users[followeeId].followed[followeeId] = true
    }
    
    this.users[followerId].followed[followeeId] = true
}

func (this *Twitter) Unfollow(followerId int, followeeId int)  {
    if followerId != followeeId {
        if user, exists := this.users[followerId]; exists {
            delete(user.followed, followeeId)
        }
    }
}

type TweetNode struct {
    tweet *Tweet
    user  *User
}

type MaxHeap []*TweetNode

func (h MaxHeap) Len() int           { return len(h) }
func (h MaxHeap) Less(i, j int) bool { return h[i].tweet.timestamp > h[j].tweet.timestamp }
func (h MaxHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MaxHeap) Push(x interface{}) {
    *h = append(*h, x.(*TweetNode))
}

func (h *MaxHeap) Pop() interface{} {
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}
```

## Link

[LeetCode 0355 Design Twitter](https://leetcode.com/problems/design-twitter/)