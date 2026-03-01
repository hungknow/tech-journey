# 1618 Maximum Font to Fit a Sentence in a Screen

## Problem Description

You want to display a sentence on a screen. The screen has a width of `w` and a height of `h`. The sentence consists of words separated by single spaces.

The font can be any size, but the font size must be an integer. For a given font size, each character has a width of `fontWidth` and a height of `fontHeight`.

You are given a function `getFontWidth(fontSize, character)` that returns the width of a character for a given font size, and `getFontHeight(fontSize)` that returns the height of a font.

Return the maximum font size that can be used to display the entire sentence on the screen. If no font size can fit, return -1.

### Example 1:
```
Input: sentence = "hello world", w = 80, h = 20
Output: 16
Explanation: Font size 16 is the largest that can fit the sentence.
```

### Example 2:
```
Input: sentence = "a b c d e f g h i j k l m n o p q r s t u v w x y z", w = 100, h = 20
Output: 6
```

## The Twist

Finding the **maximum font size** that can fit a sentence. This involves using binary search to efficiently find the largest font size that allows the sentence to fit within the screen dimensions.

## Algorithm

### Binary Search Approach:
1. Use binary search on font sizes (typically from 1 to a reasonable maximum like 1000)
2. For each font size candidate:
   - Calculate the height of the font
   - Check if the height fits within the screen height
   - Calculate how much horizontal space each word and space requires
   - Determine if the words can be arranged to fit within the screen width
3. If the font size fits, try a larger one; otherwise, try a smaller one
4. Return the maximum font size that fits

The key insight is that if a font size doesn't fit, all larger font sizes also won't fit, allowing us to use binary search to efficiently find the maximum fitting size.

## Complexity

- **Time**: O(log(maxFontSize) * n) - binary search with font fitting check
- **Space**: O(1) - constant space

## Solution Code

```go
package main

import "fmt"

/**
 * // This is the FontInfo's API interface.
 * // You should not implement it, or speculate about its implementation
 * type FontInfo interface {
 *     GetWidth(fontSize int, ch byte) int
 *     GetHeight(fontSize int) int
 * }
 */

func maxFont(text string, w int, h int, fonts []int, fontInfo FontInfo) int {
    // Binary search for the maximum font size
    left := 0
    right := len(fonts) - 1
    result := -1
    
    for left <= right {
        mid := left + (right-left)/2
        fontSize := fonts[mid]
        
        if canFit(text, w, h, fontSize, fontInfo) {
            result = fontSize
            left = mid + 1 // Try larger font
        } else {
            right = mid - 1 // Try smaller font
        }
    }
    
    return result
}

func canFit(text string, w, h, fontSize int, fontInfo FontInfo) bool {
    // Check if height fits
    if fontInfo.GetHeight(fontSize) > h {
        return false
    }
    
    // Calculate width requirements
    currentWidth := 0
    for i := 0; i < len(text); i++ {
        if text[i] == ' ' {
            // Space character
            currentWidth += fontInfo.GetWidth(fontSize, 'a') // Using 'a' as reference for space width
        } else {
            // Regular character
            charWidth := fontInfo.GetWidth(fontSize, text[i])
            if currentWidth + charWidth > w {
                // Need to move to next line
                currentWidth = charWidth
            } else {
                currentWidth += charWidth
            }
        }
    }
    
    return currentWidth <= w
}

// Mock FontInfo for testing
type FontInfo struct{}

func (fi *FontInfo) GetWidth(fontSize int, ch byte) int {
    // Simplified width calculation
    return fontSize
}

func (fi *FontInfo) GetHeight(fontSize int) int {
    // Simplified height calculation
    return fontSize
}
```

## Link

[LeetCode 1618 Maximum Font to Fit a Sentence in a Screen](https://leetcode.com/problems/maximum-font-to-fit-a-sentence-in-a-screen/)