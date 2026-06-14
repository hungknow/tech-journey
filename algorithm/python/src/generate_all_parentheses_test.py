import unittest

from src.generate_all_parentheses import generateAllParentheses

class TestGenerateAllParentheses(unittest.TestCase):
    def test(self):
        testCases = [
            (3, ["((()))","(()())","(())()","()(())","()()()"]),
            (1, ["()"])
        ]
        for testCase in testCases:
            self.assertEqual(generateAllParentheses(testCase[0]), testCase[1])
        pass