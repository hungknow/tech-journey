# 2296 Design a Text Editor

## Problem Description

Design a text editor with a cursor that can perform the following operations:

- `addText(string text)`: Appends `text` to where the cursor is currently. The cursor moves to the end of the appended text.
- `deleteText(int k)`: Deletes `k` characters to the left of the cursor. Returns the number of characters actually deleted.
- `cursorLeft(int k)`: Moves the cursor `k` characters to the left. Returns the last `min(10, len(text to the left of cursor))` characters to the left of the cursor.
- `cursorRight(int k)`: Moves the cursor `k` characters to the right. Returns the last `min(10, len(text to the left of cursor))` characters to the left of the cursor.

### Example 1:
```
Input
["TextEditor", "addText", "deleteText", "addText", "cursorRight", "cursorLeft", "deleteText", "cursorLeft", "cursorRight"]
[[], ["leetcode"], [4], ["practice"], [3], [8], [10], [2], [6]]
Output
[null, null, 4, null, "etpractice", "leet", 4, "", "practi"]

Explanation
TextEditor textEditor = new TextEditor();
textEditor.addText("leetcode"); // The current text is "leetcode".
textEditor.deleteText(4); // return 4. The current text is "leet".
textEditor.addText("practice"); // The current text is "leetpractice".
textEditor.cursorRight(3); // return "etpractice". The current text is "leetpractice".
textEditor.cursorLeft(8); // return "leet". The current text is "leetpractice".
textEditor.deleteText(10); // return 4. The current text is "practice".
textEditor.cursorLeft(2); // return "". The current text is "practice".
textEditor.cursorRight(6); // return "practi". The current text is "practi".
```

## The Twist

Implementing a text editor that efficiently supports cursor movement and text editing operations. The challenge is to handle large amounts of text efficiently.

## Algorithm

### Two Stacks Approach:
1. Use two stacks: `left` and `right`
   - `left` stores characters to the left of the cursor
   - `right` stores characters to the right of the cursor
2. For addText(text):
   - Push each character of text onto the `left` stack
3. For deleteText(k):
   - Pop up to k characters from the `left` stack
   - Return the actual number of characters deleted
4. For cursorLeft(k):
   - Move up to k characters from `left` to `right` stack
   - Return the last min(10, len(left)) characters from `left` stack
5. For cursorRight(k):
   - Move up to k characters from `right` to `left` stack
   - Return the last min(10, len(left)) characters from `left` stack

The key insight is using two stacks to represent the text split at the cursor position, allowing O(1) operations for most actions.

## Complexity

- **Time**: 
  - addText: O(l) where l is the length of text
  - deleteText: O(k) where k is the number of characters to delete
  - cursorLeft: O(k) where k is the cursor movement distance
  - cursorRight: O(k) where k is the cursor movement distance
- **Space**: O(n) where n is the total length of text

## Solution Code

```go
package main

import (
    "strings"
)

type TextEditor struct {
    left  []rune
    right []rune
}

func Constructor() TextEditor {
    return TextEditor{
        left:  make([]rune, 0),
        right: make([]rune, 0),
    }
}

func (this *TextEditor) AddText(text string)  {
    for _, char := range text {
        this.left = append(this.left, char)
    }
}

func (this *TextEditor) DeleteText(k int) int {
    deleted := 0
    for k > 0 && len(this.left) > 0 {
        this.left = this.left[:len(this.left)-1]
        deleted++
        k--
    }
    return deleted
}

func (this *TextEditor) CursorLeft(k int) string {
    for k > 0 && len(this.left) > 0 {
        // Move from left to right
        char := this.left[len(this.left)-1]
        this.left = this.left[:len(this.left)-1]
        this.right = append(this.right, char)
        k--
    }
    
    return this.getLeftString()
}

func (this *TextEditor) CursorRight(k int) string {
    for k > 0 && len(this.right) > 0 {
        // Move from right to left
        char := this.right[len(this.right)-1]
        this.right = this.right[:len(this.right)-1]
        this.left = append(this.left, char)
        k--
    }
    
    return this.getLeftString()
}

func (this *TextEditor) getLeftString() string {
    if len(this.left) == 0 {
        return ""
    }
    
    start := len(this.left) - 10
    if start < 0 {
        start = 0
    }
    
    return string(this.left[start:])
}
```

## Link

[LeetCode 2296 Design a Text Editor](https://leetcode.com/problems/design-a-text-editor/)