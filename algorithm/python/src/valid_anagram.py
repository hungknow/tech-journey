# https://leetcode.com/problems/valid-anagram/

def isAnagram(s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    return sorted(s) == sorted(t)

def isAnagram2(s: str, t: str) -> bool:
    if len(s) != len(t):
        return False
    char_map = [0] * 26
    for i in range(len(s)):
        char_map[ord(s[i]) - ord('a')] += 1
        char_map[ord(t[i]) - ord('a')] -= 1
    return all(count == 0 for count in char_map)
