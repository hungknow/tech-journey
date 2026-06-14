# https://leetcode.com/problems/largest-rectangle-in-histogram/
from typing import List

def largestRectangleInHistogram(heights: List[int]) -> int:
    stack = []
    max_area = 0
    for i in range(len(heights)):
        height = heights[i]
        if not stack:
            stack.append((i, height)) 
        elif height < stack[-1][1]:
            index = i
            while stack and stack[-1][1] > height:
                index, h = stack.pop()
                area = h * (i - index)
                max_area = max(max_area, area)
            stack.append((index, height))
        else:
            stack.append((i, height))
    max_length = len(heights)
    # print('final', stack)
    while stack:
        index, h = stack.pop()
        max_area = max(max_area, (max_length - index) * h)
    return max_area
