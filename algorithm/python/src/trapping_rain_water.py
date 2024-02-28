
from typing import List

# https://leetcode.com/problems/trapping-rain-water/description/
def trappingRainWater(height: List[int]) -> int:
    j = 0
    n = len(height)
    r = n - 1
    lMax = 0
    rMax = 0
    area = 0
    while j < r:
        if height[j] < height[r]:
            lMax = max(lMax, height[j])
            area += lMax - height[j]
            j += 1
        else:
            rMax = max(rMax, height[r])
            area += rMax - height[r]
            r -= 1
        
    return area