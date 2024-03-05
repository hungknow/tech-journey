# https://leetcode.com/problems/koko-eating-bananas/description/
from typing import List

def minEatingSpeed(piles: List[int], h: int) -> int:
    l = 1
    r = max(piles)
    min_speed = r
    while l <= r:
        m = (l + r) // 2
        eating_hour = sum((pile + m - 1) // m for pile in piles) 
        if eating_hour <= h:
            min_speed = min(min_speed, m)
            r = m - 1
        else:
            l = m + 1
    
    return min_speed

