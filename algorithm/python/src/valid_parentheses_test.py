import unittest

from src.valid_parentheses import validParentheses

class TestValidParentheses(unittest.TestCase):
    def test(self):
        test_cases = [
            ("[", False)
            ("((", False)
            ("()", True),
            ("()[]{}", True),
            ("(]", False),
        ]
        for s, t, expected in test_cases:
            self.assertEqual(validParentheses(s, t), expected)
