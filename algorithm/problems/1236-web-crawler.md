# 1236 Web Crawler

## Problem Description

Given a url `startUrl` and an interface `HtmlParser`, implement a web crawler to crawl all links that are under the same hostname as `startUrl`.

Your crawler should:

1. Start from the page `startUrl`
2. Call `HtmlParser.getUrls(url)` to get all urls from a webpage of the given url
3. Do not crawl the same link twice
4. Explore all the urls that are under the same hostname as `startUrl`

As shown in the example url above, the hostname is `example.org`. For simplicity sake, you may assume all urls use http protocol without any port specified. For example, the urls `http://example.org` and `http://example.org/test` are under the same hostname, while `http://example.com` and `http://example.com/test` are not.

### Example 1:
```
Input:
urls = [
  "http://news.yahoo.com",
  "http://news.yahoo.com/news",
  "http://news.yahoo.com/news/topics",
  "http://news.google.com",
  "http://news.yahoo.com/us"
]
edges = [[2,0],[2,1],[3,2],[3,4],[3,5],[4,5],[5,6]]
startUrl = "http://news.yahoo.com/news/topics/1"
Output: ["http://news.yahoo.com/news","http://news.yahoo.com","http://news.yahoo.com/news/topics/1"]
Explanation:
```

## The Twist

Implementing a web crawler that efficiently explores all pages under the same hostname while avoiding duplicate visits and handling the web graph structure.

## Algorithm

### BFS/DFS with Hostname Filtering Approach:
1. Extract the hostname from the startUrl
2. Use a queue (for BFS) or stack (for DFS) to manage URLs to visit
3. Use a set to track visited URLs
4. Add startUrl to the queue and visited set
5. While the queue is not empty:
   - Dequeue a URL
   - Add it to the result
   - Get all URLs from this page using HtmlParser.getUrls
   - For each URL:
     - Check if it has the same hostname as the startUrl
     - If not visited, add to queue and visited set
6. Return the result list

The key insight is using BFS/DFS to traverse the web graph while filtering URLs by hostname and avoiding cycles.

## Complexity

- **Time**: O(|V| + |E|) where |V| is the number of pages and |E| is the number of links
- **Space**: O(|V|) for the visited set and queue/stack

## Solution Code

```go
package main

import (
	"net/url"
	"strings"
)

/**
 * Definition for HtmlParser.
 * type HtmlParser struct {
 *     func GetUrls(string) []string
 * }
 */

func Crawl(startUrl string, htmlParser HtmlParser) []string {
	// Extract hostname from startUrl
	startHostname := getHostname(startUrl)
	
	// Initialize data structures
	visited := make(map[string]bool)
	queue := []string{startUrl}
	visited[startUrl] = true
	result := make([]string, 0)
	
	// BFS traversal
	for len(queue) > 0 {
		currentUrl := queue[0]
		queue = queue[1:]
		result = append(result, currentUrl)
		
		// Get all URLs from current page
		urls := htmlParser.GetUrls(currentUrl)
		
		for _, url := range urls {
			// Check if URL has the same hostname and hasn't been visited
			if !visited[url] && getHostname(url) == startHostname {
				visited[url] = true
				queue = append(queue, url)
			}
		}
	}
	
	return result
}

func getHostname(urlStr string) string {
	u, err := url.Parse(urlStr)
	if err != nil {
		return ""
	}
	return u.Hostname()
}

// Alternative implementation without using net/url package
func getHostnameSimple(urlStr string) string {
	// Remove protocol
	if strings.HasPrefix(urlStr, "http://") {
		urlStr = urlStr[7:]
	} else if strings.HasPrefix(urlStr, "https://") {
		urlStr = urlStr[8:]
	}
	
	// Extract hostname (everything up to first '/')
	parts := strings.SplitN(urlStr, "/", 2)
	return parts[0]
}
```

## Link

[LeetCode 1236 Web Crawler](https://leetcode.com/problems/web-crawler/)