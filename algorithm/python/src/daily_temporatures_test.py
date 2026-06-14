import unittest

from src.daily_temporatures import dailyTemperatures

class TestDailyTemporatures(unittest.TestCase):
    def test(self):
        testCases = [
            ([73,74,75,71,69,72,76,73], [1,1,4,2,1,1,0,0]),
            ([30,40,50,60], [1,1,1,0]),
            ([30,60,90], [1,1,0])
        ]
        for testCase in testCases:
            self.assertEqual(dailyTemperatures(testCase[0]), testCase[1])
        pass