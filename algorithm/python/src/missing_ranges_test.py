import unittest
from src.missing_ranges import findMissingRanges

class TestFindMissingRanges(unittest.TestCase):
    def test_find_mis(self):
        self.assertEqual(findMissingRanges([0, 1, 3, 50, 75], 0, 99), [[2, 2], [4, 49], [51, 74], [76, 99]]) 
        self.assertEqual(findMissingRanges([-1], -1, -1), [])