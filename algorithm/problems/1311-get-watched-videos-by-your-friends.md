# 1311 Get Watched Videos by Your Friends

## Problem Description

You are given:
- `watchedVideos`: a list where `watchedVideos[i]` is a list of videos watched by person `i`
- `friends`: a 2D list where `friends[i]` is a list of friends of person `i`
- `id`: your ID
- `level`: the friend level to consider

Return the list of videos watched by your friends at the specified `level`, sorted lexicographically.

### Example 1:
```
Input: watchedVideos = [["A","B"],["C"],["B","C"],["D"]], friends = [[1,2],[0,3],[0,3],[1,2]], id = 0, level = 1
Output: ["B","C"]
```

### Example 2:
```
Input: watchedVideos = [["A","B"],["C"],["B","C"],["D"]], friends = [[1,2],[0,3],[0,3],[1,2]], id = 0, level = 2
Output: ["D"]
```

## Approach

This problem can be solved using BFS to find friends at the specified level:

1. **BFS for Friends**:
   - Start BFS from your ID
   - Find all friends at the specified level
   - Track visited friends to avoid cycles

2. **Video Collection**:
   - Collect all videos watched by friends at the target level
   - Count the frequency of each video

3. **Sorting**: Sort the videos lexicographically

## Solution Code

```go
func watchedVideosByFriends(watchedVideos [][]string, friends [][]int, id int, level int) []string {
    n := len(friends)
    
    // BFS to find friends at the specified level
    queue := []int{id}
    visited := make([]bool, n)
    visited[id] = true
    
    currentLevel := 0
    targetFriends := []int{}
    
    for len(queue) > 0 && currentLevel <= level {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            if currentLevel == level {
                targetFriends = append(targetFriends, current)
                continue
            }
            
            // Add friends to queue
            for _, friend := range friends[current] {
                if !visited[friend] {
                    visited[friend] = true
                    queue = append(queue, friend)
                }
            }
        }
        
        currentLevel++
    }
    
    // Collect videos from target friends
    videoCount := make(map[string]int)
    
    for _, friend := range targetFriends {
        for _, video := range watchedVideos[friend] {
            videoCount[video]++
        }
    }
    
    // Extract and sort videos
    videos := make([]string, 0, len(videoCount))
    for video := range videoCount {
        videos = append(videos, video)
    }
    
    sort.Strings(videos)
    
    return videos
}
```

## Complexity Analysis

- **Time**: O(V + E + V log V) where V is the number of people and E is the number of friendships
  - BFS: O(V + E)
  - Sorting videos: O(V log V) in the worst case
- **Space**: O(V) for the visited array, queue, and video counting

## Link

[LeetCode 1311 Get Watched Videos by Your Friends](https://leetcode.com/problems/get-watched-videos-by-your-friends/)