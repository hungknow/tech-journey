# 2227 Encrypt and Decrypt Strings

## Problem Description

You are given a string `s` and an integer `k`. Design a class to encrypt and decrypt strings.

Implement the `Codec` class:

- `Codec(int k)` Initializes the object with the given key `k`.
- `string encrypt(string s)` Encrypts the string `s` and returns the encrypted string.
- `string decrypt(string s)` Decrypts the string `s` and returns the decrypted string.

The encryption and decryption rules are as follows:
- For encryption:
  1. For each character `c` in the string `s`, replace it with the character that is `k` positions after `c` in the alphabet.
  2. Reverse the entire string.
- For decryption:
  1. Reverse the string.
  2. For each character `c` in the string, replace it with the character that is `k` positions before `c` in the alphabet.

### Example 1:
```
Input
["Codec","encrypt","decrypt","encrypt","decrypt"]
[[2],["hello"],["jkij"],["jijig"]]
Output
[null,"jijig","hello","jkij"]

Explanation
Codec codec = new Codec(2);
codec.encrypt("hello"); // return "jijig"
codec.decrypt("jijig"); // return "hello"
codec.encrypt("jkij");  // return "hello"
codec.decrypt("hello"); // return "jkij"
```

## The Twist

Implementing an encryption/decryption system that uses a simple Caesar cipher-like shift based on a key value.

## Algorithm

### String Manipulation Approach:
1. For Codec(k):
   - Store the key value
2. For encrypt(s):
   - For each character, shift it by k positions forward in the alphabet
   - Reverse the entire string
3. For decrypt(s):
   - Reverse the string
   - For each character, shift it by k positions backward in the alphabet
   - Return the result

The key insight is using character shifting and string reversal to implement the encryption/decryption efficiently.

## Complexity

- **Time**: 
  - Codec constructor: O(1)
  - encrypt: O(n) where n is the length of the string
  - decrypt: O(n) where n is the length of the string
- **Space**: O(n) where n is the length of the string

## Solution Code

```go
package main

import "unicode"

type Codec struct {
	k int
}

func Constructor(k int) Codec {
	return Codec{
		k: k,
	}
}

func (this *Codec) Encrypt(s string) string {
	// Shift each character by k positions
	encrypted := make([]rune, len(s))
	for i, char := range s {
		encrypted[i] = shift(char, this.k)
	}
	
	// Reverse the entire string
	for i, j := 0, i < len(encrypted)/2; i, j = len(encrypted)-1-i-1 {
		encrypted[i], encrypted[j] = encrypted[j], encrypted[i]
	}
	
	return string(encrypted)
}

func (this *Codec) Decrypt(s string) string {
	// Reverse the string
	reversed := reverseString(s)
	
	// Shift each character backward by k positions
	decrypted := make([]rune, len(reversed))
	for i, char := range reversed {
		decrypted[i] = shift(char, -this.k)
	}
	
	return string(decrypted)
}

func shift(char rune, k int) rune {
	if char >= 'a' && char <= 'z' {
		// Shift within lowercase letters
		return 'a' + ((char-'a'+rune(k)+26)%26)
	} else if char >= 'A' && char <= 'Z' {
		// Shift within uppercase letters
		return 'A' + ((char-'A'+rune(k)+26)%26)
	}
	
	return char
}

func reverseString(s string) string {
	runes := []rune(s)
	for i, j := 0, i < len(runes)/2; i, j = len(runes)-1-i-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

/**
 * Your Codec object will be instantiated and called as such:
 * obj := Constructor(k);
 * param_1 := obj.Encrypt(s);
 * param_2 := obj.Decrypt(s);
 */
```

## Link

[LeetCode 2227 Encrypt and Decrypt Strings](https://leetcode.com/problems/encrypt-and-decrypt-strings/)