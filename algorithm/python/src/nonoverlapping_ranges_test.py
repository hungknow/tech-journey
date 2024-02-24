import unittest
from src.nonoverlapping_ranges import nonOverlappingRanges

class TestNonOverlappingRanges(unittest.TestCase):
    def test(self):
        self.assertEqual(nonOverlappingRanges(
            [(1, 3), (2, 4), (5, 7), (6, 8)]), 
            [(1, 4), (5, 8)])