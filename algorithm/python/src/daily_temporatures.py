# https://leetcode.com/problems/daily-temperatures/

from typing import List

def dailyTemperatures(temperatures: List[int]) -> List[int]:
    results = [0] * len(temperatures) 
    stack = []
    for i in range(len(temperatures)):
        while stack and temperatures[i] > temperatures[stack[-1]]:
            idx = stack.pop()
            results[idx] = i - idx
        stack.append(i)
    
    return results