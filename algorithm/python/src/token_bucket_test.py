import time
import unittest

from src.token_bucket import TokenBucket

class TokenBucketTest(unittest.TestCase):
    def test1(self):
        throttle = TokenBucket(1, 1)
        self.assertEqual(throttle.consume(1), 0)
        self.assertEqual(throttle.consume(1), 1)
        self.assertEqual(throttle.consume(1), 1)
        self.assertEqual(throttle.consume(1), 1)
        time.sleep(1)
        self.assertEqual(throttle.consume(1), 0)
        time.sleep(0.5)
        self.assertEqual(throttle.consume(1), 1)
        time.sleep(0.5)
        self.assertEqual(throttle.consume(1), 0)
        time.sleep(2)
        self.assertEqual(throttle.consume(2), 1)

    def test2(self):
        throttle = TokenBucket(2, 1)
        self.assertEqual(throttle.consume(1), 0)
        self.assertEqual(throttle.consume(1), 0)
        self.assertEqual(throttle.consume(1), 1)
        self.assertEqual(throttle.consume(1), 1)
        time.sleep(1)
        self.assertEqual(throttle.consume(2), 0)
        time.sleep(0.45)
        self.assertEqual(throttle.consume(1), 1)
        time.sleep(0.05)
        self.assertEqual(throttle.consume(1), 0)
        time.sleep(0.5)
        self.assertEqual(throttle.consume(1), 0)
        time.sleep(1)
        self.assertEqual(throttle.consume(2), 0)