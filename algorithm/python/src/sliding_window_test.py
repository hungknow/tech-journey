import time
import unittest
from src.sliding_window import SlidingWindow

class SlidingWindowTest(unittest.TestCase):
    def test_consume(self):
        current_time = 1.0
        # Create a sliding window with capacity 10 and time unit 1 second
        sliding_window = SlidingWindow(10, 1, lambda: current_time)

        # Test consuming when the current count is less than the capacity
        self.assertEqual(sliding_window.cur_count, 0)

        self.assertEqual(sliding_window.consume(10), 0)
        self.assertEqual(sliding_window.consume(5), 5)
        current_time += 1.5
        self.assertEqual(sliding_window.consume(5), 0)
        self.assertEqual(sliding_window.consume(5), 5)
        current_time += 0.5
        self.assertEqual(sliding_window.consume(5), 0)
        current_time += 0.5
        self.assertEqual(sliding_window.consume(5), 0)
        self.assertEqual(sliding_window.consume(1), 1)
        current_time += 0.1
        self.assertEqual(sliding_window.consume(1), 0)
               