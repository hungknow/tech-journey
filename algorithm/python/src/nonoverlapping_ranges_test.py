import unittest
from nonoverlapping_ranges import nonOverlappingRanges


class TestNonOverlappingRanges(unittest.TestCase):
    
    def test_empty_input(self):
        """Test with empty list of ranges"""
        self.assertEqual(nonOverlappingRanges([]), [])
    
    def test_single_range(self):
        """Test with a single range"""
        self.assertEqual(nonOverlappingRanges([(1, 5)]), [(1, 5)])
    
    def test_non_overlapping_ranges(self):
        """Test with ranges that don't overlap"""
        ranges = [(1, 3), (5, 7), (10, 15)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 3), (5, 7), (10, 15)])
    
    def test_overlapping_ranges(self):
        """Test with overlapping ranges"""
        ranges = [(1, 5), (3, 7), (6, 10)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 10)])
    
    def test_adjacent_ranges(self):
        """Test with adjacent ranges (end == start)"""
        ranges = [(1, 5), (5, 10)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 5), (5, 10)])
    
    def test_contained_ranges(self):
        """Test with one range contained within another"""
        ranges = [(1, 10), (3, 5), (6, 8)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 10)])
    
    def test_unsorted_input(self):
        """Test with unsorted input ranges"""
        ranges = [(5, 10), (1, 3), (7, 12)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 3), (5, 12)])
    
    def test_multiple_overlaps(self):
        """Test with multiple overlapping ranges"""
        ranges = [(1, 4), (2, 6), (5, 8), (7, 10)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 10)])
    
    def test_partial_overlaps(self):
        """Test with partial overlapping ranges"""
        ranges = [(1, 5), (4, 8), (10, 15), (14, 20)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 8), (10, 20)])
    
    def test_reverse_order(self):
        """Test with ranges in reverse order"""
        ranges = [(10, 15), (5, 7), (1, 3)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 3), (5, 7), (10, 15)])
    
    def test_same_start_different_end(self):
        """Test with ranges starting at same point but different ends"""
        ranges = [(1, 5), (1, 8), (1, 3)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 8)])
    
    def test_complex_case(self):
        """Test with a complex mix of overlapping and non-overlapping ranges"""
        ranges = [(1, 3), (2, 6), (8, 10), (15, 20), (18, 25)]
        self.assertEqual(nonOverlappingRanges(ranges), [(1, 6), (8, 10), (15, 25)])


if __name__ == '__main__':
    unittest.main()
