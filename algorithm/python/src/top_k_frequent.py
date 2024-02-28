from typing import List

# https://leetcode.com/problems/top-k-frequent-elements/description/
# Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.
def topKFrequent(nums: List[int], k: int) -> List[int]:
    nums.sort()
    counts = {}
    for num in nums:
        counts[num] = 1 + counts.get(num, 0)

    counts = sorted(counts.items(), key=lambda x: x[1], reverse=True)
    result = [key for key,v in counts[:k]]
    if result:
        result.sort()
    return result
