# Input: s = "abcabcbb"
# Output: 3
# Explanation: The answer is "abc", with the length of 3. Note that "bca" and "cab" are also correct answers.

# Input: s = "bbbbb"
# Output: 1
# Explanation: The answer is "b", with the length of 1.

# Input: s = "pwwkew"
# Output: 3
# Explanation: The answer is "wke", with the length of 3.
# Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

# https://leetcode.com/problems/longest-substring-without-repeating-characters/
class Solution:
    # Hash table
    def length_of_nearest_duplicated_character(self, s: str) -> int:
        # create the array with 128 elements, initialized to -1
        # current max length = 0
        # iterate through the string
            # for each character, 
                # max_repeated_length_of_current_character = Compare the current index with the value stored in the array at the ASCII code of the character, get the greater value
                # max value = max(max_length of current character, current max length)
                # update the value stored in the array at the ASCII code of the character with the current index

    # Sliding window
    def sliding_window(self, s: str) -> int:
        # left = 0
        # ans = 0
        # create the array with 128 elements, initialized to 0
        # iterate through the string
            # for each character,
                # increment the value stored in the array at the ASCII code of the character by 1
                # in order to find the nearest duplicated character, as long as the value stored in the array at the current index greater than 1, decrease the value stored at the left index by 1
                # left = left + 1
                # ans = max(ans, current index - left + 1)
        # return ans
        