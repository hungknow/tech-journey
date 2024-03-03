import unittest

from src.evaluate_reverse_polish_notation import evaluateReversePolishNotation

class TestEvaluateReversePolishNotation(unittest.TestCase):
    def test(self):
        testCases = [
            #  ((2 + 1) * 3) = 9
            (["2","1","+","3","*"], 9),
            # (4 + (13 / 5)) = 6
            (["4","13","5","/","+"],  6),
            # (10 * (6 / ((9 + 3) * -11))) + 17) + 5
            (["10","6","9","3","+","-11","*","/","*","17","+","5","+"], 22)
        ]
        for testCase in testCases:
            self.assertEqual(evaluateReversePolishNotation(testCase[0]), testCase[1])
        pass