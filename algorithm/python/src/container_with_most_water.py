from typing import List

# https://leetcode.com/problems/container-with-most-water/description/
def containerWithMostWater(height: List[int]) -> int:
    j = 0
    n = len(height)
    k = n - 1

    max_area = 0
    while j < k:
        area = min(height[j], height[k]) * (k - j)
        if area > max_area:
            max_area = area
 
        if height[j] < height[k]:
            j += 1
        else:
            k -= 1

    return max_area
    
