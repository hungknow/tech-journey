# 1472 Design Browser History

## Problem Description

You have a browser of one tab where you start on the homepage and you can visit another url, you can go back in history and you can go forward in history.

Implement the `BrowserHistory` class:

- `BrowserHistory(string homepage)` Initializes the object with the homepage of the browser.
- `void visit(string url)` Visits url from the current page. It clears up all the forward history.
- `string back(int steps)` Move steps back in history. If you can only return x steps in the history and steps > x, you will return only x steps. Return the current url after moving back in history at most steps.
- `string forward(int steps)` Move steps forward in history. If you can only forward x steps in the history and steps > x, you will forward only x steps. Return the current url after forwarding in history at most steps.

### Example 1:
```
Input:
["BrowserHistory","visit","visit","visit","back","back","forward","visit","forward","back","back"]
[["leetcode.com"],["google.com"],["facebook.com"],["youtube.com"],[1],[1],[1],["linkedin.com"],[2],[2],[7]]
Output:
[null,null,null,null,"facebook.com","google.com","facebook.com",null,"linkedin.com","google.com","leetcode.com"]

Explanation:
BrowserHistory browserHistory = new BrowserHistory("leetcode.com");
browserHistory.visit("google.com");       // You are in "leetcode.com". Visit "google.com"
browserHistory.visit("facebook.com");     // You are in "google.com". Visit "facebook.com"
browserHistory.visit("youtube.com");      // You are in "facebook.com". Visit "youtube.com"
browserHistory.back(1);                   // You are in "youtube.com", move back to "facebook.com" return "facebook.com"
browserHistory.back(1);                   // You are in "facebook.com", move back to "google.com" return "google.com"
browserHistory.forward(1);                 // You are in "google.com", move forward to "facebook.com" return "facebook.com"
browserHistory.visit("linkedin.com");      // You are in "facebook.com". Visit "linkedin.com"
browserHistory.forward(2);                 // You are in "linkedin.com", you cannot move forward any steps.
browserHistory.back(2);                   // You are in "linkedin.com", move back two steps to "facebook.com" then to "google.com". return "google.com"
browserHistory.back(7);                   // You are in "google.com", you can move back only one step to "leetcode.com". return "leetcode.com"
```

## The Twist

Implementing a browser history system that efficiently supports visiting URLs, moving back and forward through history with proper management of the history stack.

## Algorithm

### Doubly Linked List + Index Approach:
1. Use a doubly linked list to store the visited URLs
2. Maintain a pointer to the current page
3. For BrowserHistory(homepage):
   - Initialize with the homepage as the only node
   - Set current pointer to this node
4. For visit(url):
   - Create a new node with the URL
   - Clear all forward history by setting new node's next to nil
   - Link current node to new node
   - Update current pointer to new node
5. For back(steps):
   - Move back steps times or until reaching the beginning
   - Return the URL at the current position
6. For forward(steps):
   - Move forward steps times or until reaching the end
   - Return the URL at the current position

The key insight is using a doubly linked list to efficiently navigate back and forward through the browser history.

## Complexity

- **Time**: 
  - BrowserHistory constructor: O(1)
  - visit: O(1)
  - back: O(min(steps, history_size))
  - forward: O(min(steps, history_size))
- **Space**: O(n) where n is the number of visited URLs

## Solution Code

```go
package main

type HistoryNode struct {
	url  string
	prev *HistoryNode
	next *HistoryNode
}

type BrowserHistory struct {
	current *HistoryNode
}

func Constructor(homepage string) BrowserHistory {
	head := &HistoryNode{
		url:  homepage,
		prev: nil,
		next: nil,
	}
	
	return BrowserHistory{
		current: head,
	}
}

func (this *BrowserHistory) Visit(url string)  {
	// Create new node
	newNode := &HistoryNode{
		url:  url,
		prev: this.current,
		next: nil,
	}
	
	// Clear forward history
	this.current.next = newNode
	
	// Update current
	this.current = newNode
}

func (this *BrowserHistory) Back(steps int) string {
	// Move back steps times or until reaching the beginning
	for i := 0; i < steps && this.current.prev != nil; i++ {
		this.current = this.current.prev
	}
	
	return this.current.url
}

func (this *BrowserHistory) Forward(steps int) string {
	// Move forward steps times or until reaching the end
	for i := 0; i < steps && this.current.next != nil; i++ {
		this.current = this.current.next
	}
	
	return this.current.url
}

/**
 * Your BrowserHistory object will be instantiated and called as such:
 * obj := Constructor(homepage);
 * obj.Visit(url);
 * param_2 := obj.Back(steps);
 * param_3 := obj.Forward(steps);
 */
```

## Link

[LeetCode 1472 Design Browser History](https://leetcode.com/problems/design-browser-history/)