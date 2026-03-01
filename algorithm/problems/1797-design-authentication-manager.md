# 1797 Design Authentication Manager

## Problem Description

Design an authentication manager that supports user authentication with a time-to-live (TTL) feature.

Implement the `AuthenticationManager` class:

- `AuthenticationManager(int timeToLive)` Initializes the authentication manager with the given `timeToLive`.
- `void generate(string tokenId, int currentTime)` Generates a new token with ID `tokenId` at the given `currentTime`.
- `void renew(string tokenId, int currentTime)` Renews the token with ID `tokenId` at the given `currentTime`.
- `int countUnexpiredTokens(int currentTime)` Returns the number of unexpired tokens at the given `currentTime`.

A token is considered expired if it was generated more than `timeToLive` seconds ago.

### Example 1:
```
Input
["AuthenticationManager","renew","generate","renew","unrenew","generate","countUnexpiredTokens","renew","countUnexpiredTokens"]
[[5],["aaa",1],["aaa",2],["bbb",3],["aaa",4],["aaa",5],[6],["bbb",7],[8]]
Output
[null,null,null,null,1,null,2,null,1]

Explanation
AuthenticationManager authenticationManager = new AuthenticationManager(5); // Tokens expire after 5 seconds.
authenticationManager.renew("aaa", 1); // No token exists with ID "aaa" at time 1.
authenticationManager.generate("aaa", 2); // Generates token "aaa" at time 2.
authenticationManager.renew("bbb", 3); // No token exists with ID "bbb" at time 3.
authenticationManager.renew("aaa", 4); // Token "aaa" is unexpired at time 4, so it is renewed.
authenticationManager.unrenew("aaa", 4); // Token "aaa" is renewed at time 4, so it is not expired.
authenticationManager.generate("bbb", 5); // Generates token "bbb" at time 5.
authenticationManager.countUnexpiredTokens(6); // 2 tokens are unexpired at time 6.
authenticationManager.renew("bbb", 7); // Token "bbb" is unexpired at time 7, so it is renewed.
authenticationManager.countUnexpiredTokens(8); // 1 token is unexpired at time 8.
```

## The Twist

Implementing an authentication manager that efficiently tracks token generation, renewal, and expiration based on time-to-live.

## Algorithm

### HashMap + TTL Approach:
1. Use a HashMap to store token IDs and their generation times
2. For AuthenticationManager(timeToLive):
   - Store the timeToLive value
3. For generate(tokenId, currentTime):
   - Store the token ID with its generation time
4. For renew(tokenId, currentTime):
   - Check if the token exists and is not expired
   - If valid, update its generation time to currentTime
5. For countUnexpiredTokens(currentTime):
   - Count all tokens whose generation time is within the timeToLive window
   - Remove expired tokens from the HashMap

The key insight is tracking generation times and efficiently checking expiration based on the time-to-live value.

## Complexity

- **Time**: 
  - AuthenticationManager constructor: O(1)
  - generate: O(1)
  - renew: O(1)
  - countUnexpiredTokens: O(n) where n is the number of tokens
- **Space**: O(n) where n is the number of tokens

## Solution Code

```go
package main

import "time"

type AuthenticationManager struct {
	tokens    map[string]time.Time
	timeToLive time.Duration
}

func Constructor(timeToLive int) AuthenticationManager {
	return AuthenticationManager{
		tokens:    make(map[string]time.Time),
		timeToLive: time.Duration(timeToLive) * time.Second,
	}
}

func (this *AuthenticationManager) Generate(tokenId string, currentTime int)  {
	// Convert currentTime to time.Time
	t := time.Unix(int64(currentTime), 0)
	this.tokens[tokenId] = t
}

func (this *AuthenticationManager) Renew(tokenId string, currentTime int)  {
	// Convert currentTime to time.Time
	t := time.Unix(int64(currentTime), 0)
	
	// Check if token exists and is not expired
	if genTime, exists := this.tokens[tokenId]; exists {
		if t.Sub(genTime) < this.timeToLive {
			// Renew the token by updating its generation time
			this.tokens[tokenId] = t
		}
	}
}

func (this *AuthenticationManager) CountUnexpiredTokens(currentTime int) int {
	// Convert currentTime to time.Time
	t := time.Unix(int64(currentTime), 0)
	
	count := 0
	expiredTokens := make([]string, 0)
	
	// Count unexpired tokens and collect expired ones
	for tokenId, genTime := range this.tokens {
		if t.Sub(genTime) < this.timeToLive {
			count++
		} else {
			expiredTokens = append(expiredTokens, tokenId)
		}
	}
	
	// Remove expired tokens
	for _, tokenId := range expiredTokens {
		delete(this.tokens, tokenId)
	}
	
	return count
}

/**
 * Your AuthenticationManager object will be instantiated and called as such:
 * obj := Constructor(timeToLive);
 * obj.Generate(tokenId,currentTime);
 * obj.Renew(tokenId,currentTime);
 * param_4 := obj.CountUnexpiredTokens(currentTime);
 */
```

## Link

[LeetCode 1797 Design Authentication Manager](https://leetcode.com/problems/design-authentication-manager/)