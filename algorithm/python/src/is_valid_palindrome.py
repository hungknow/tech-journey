# https://leetcode.com/problems/valid-palindrome/description/
def isValidPalindrome(s: str) -> bool:
    firstIndex = 0
    lastIndex = len(s) - 1

    while firstIndex < lastIndex: 
        while firstIndex < lastIndex and s[firstIndex].isalnum() == False:
            firstIndex += 1
        while lastIndex > firstIndex and s[lastIndex].isalnum() == False:
            lastIndex -= 1
        if s[firstIndex].lower() != s[lastIndex].lower():
            return False
        firstIndex += 1
        lastIndex -= 1

    return True