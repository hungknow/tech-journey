# 0535 Encode and Decode TinyURL

## Problem Description

Note: This is a companion problem to the System Design problem: Design TinyURL.

TinyURL is a URL shortening service where you enter a URL such as `https://leetcode.com/problems/design-tinyurl` and it returns a short URL such as `http://tinyurl.com/4e9iAK`.

Design a class to encode a URL and decode a tiny URL.

Implement the `Codec` class:

- `Codec()` Initializes the object of the system.
- `String encode(String longUrl)` Returns a tiny URL for the given `longUrl`.
- `String decode(String shortUrl)` Returns the original long URL for the given `shortUrl`. It is guaranteed that the given `shortUrl` was encoded by the same codec.

### Example 1:
```
Input: url = "https://leetcode.com/problems/design-tinyurl"
Output: "https://leetcode.com/problems/design-tinyurl"

Explanation:
Codec codec = new Codec();
codec.decode(codec.encode(url)); // Returns the original long URL
```

## The Twist

Implementing a URL shortening service that efficiently maps long URLs to short URLs and vice versa, ensuring unique and reversible encoding.

## Algorithm

### Hash Map + Counter Approach:
1. Use a counter to generate unique IDs for each long URL
2. Use a HashMap to map long URLs to their corresponding IDs
3. Use another HashMap to map IDs back to long URLs
4. For encode(longUrl):
   - Check if longUrl already has an ID
   - If not, generate a new ID using the counter
   - Store the mapping in both HashMaps
   - Increment the counter
   - Return the short URL using the ID
5. For decode(shortUrl):
   - Extract the ID from the short URL
   - Look up the ID in the ID-to-URL HashMap
   - Return the corresponding long URL

The key insight is using a simple counter-based approach with bidirectional HashMaps for efficient encoding and decoding.

## Complexity

- **Time**: 
  - encode: O(1) average
  - decode: O(1) average
- **Space**: O(n) where n is the number of URLs stored

## Solution Code

```go
package main

import (
	"strconv"
	"strings"
)

type Codec struct {
	urlToID map[string]string
	idToURL map[string]string
	counter int
}

func Constructor() Codec {
	return Codec{
		urlToID: make(map[string]string),
		idToURL: make(map[string]string),
		counter: 1,
	}
}

// Encodes a URL to a shortened URL.
func (this *Codec) encode(longURL string) string {
	if id, exists := this.urlToID[longURL]; exists {
		return "http://tinyurl.com/" + id
	}
	
	id := strconv.Itoa(this.counter)
	this.urlToID[longURL] = id
	this.idToURL[id] = longURL
	this.counter++
	
	return "http://tinyurl.com/" + id
}

// Decodes a shortened URL to its original URL.
func (this *Codec) decode(shortURL string) string {
	parts := strings.Split(shortURL, "/")
	id := parts[len(parts)-1]
	
	if url, exists := this.idToURL[id]; exists {
		return url
	}
	
	return ""
}

/**
 * Your Codec object will be instantiated and called as such:
 * obj := Constructor();
 * url := obj.encode(longUrl);
 * ans := obj.decode(url);
 */
```

## Link

[LeetCode 0535 Encode and Decode TinyURL](https://leetcode.com/problems/encode-and-decode-tinyurl/)