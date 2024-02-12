# Test cases for isAnagram
from src.valid_anagram import isAnagram, isAnagram2
import unittest

class ValidAnagram(unittest.TestCase):
    def test(self):
        test_cases = [
            ("anagram", "nagaram", True),
            ("rat", "car", False),
            ("listen", "silent", True),
            ("hello", "world", False)
        ]
        for s, t, expected in test_cases:
            self.assertEqual(isAnagram(s, t), expected)
            self.assertEqual(isAnagram2(s, t), expected)
