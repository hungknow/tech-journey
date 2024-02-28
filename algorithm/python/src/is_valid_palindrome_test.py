import unittest

from src.is_valid_palindrome import isValidPalindrome

class TestIsValidpalindrome(unittest.TestCase):
    def test(self):
        testCases = [
            ("A man, a plan, a canal: Panama", True),
            ("race a car", False),
            (" ", True),
            ("0P", False),
            ("a", True)
        ]

        for testCase in testCases:
            self.assertEqual(isValidPalindrome(testCase[0]), testCase[1], msg = testCase[0])