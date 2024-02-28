from typing import List

# https://leetcode.com/problems/3sum/description/
# https://algo.monster/liteproblems/15
# Two pointers
def threeSum(nums: List[int]) -> List[int]:
    nums = sorted(nums)
    triples = []
    n = len(nums)

    for num_index, num in enumerate(nums):
        if num > 0:
            break
        j = num_index + 1
        k = n - 1
        if num_index > 0 and num == nums[num_index - 1]:
            continue

        while j < k:
            sum = num + nums[j] + nums[k]
            if sum == 0:
                new_triple = [num, nums[j], nums[k]]
                triples.append(new_triple)
                j += 1
                k -= 1
                while j < k and nums[j] == nums[j - 1]:
                    j += 1
                while k > j and nums[k] == nums[k + 1]:
                    k -= 1
            elif sum < 0:
                j += 1
            else:
                k -= 1
    return triples 


# Hash map
def threeSum2(nums: List[int]) -> List[int]:
    nums = sorted(nums)
    triples = []
    n = len(nums)
    dict = {}
    for i in range(n):
        dict[nums[i]] = i

    for num_index in range(n):
        num = nums[num_index]
        if num > 0:
            break
        if num_index > 0 and num == nums[num_index - 1]:
            continue
        j = num_index + 1
        while j < n:
            target = -1 * (num + nums[j])
            if target in dict and dict[target] > j:
                # print('target', target)
                new_triple = [num, nums[j], target]
                triples.append(new_triple)
                j += 1
                while j < n and nums[j] == nums[j - 1]:
                    j += 1
            else:
                j += 1
    return triples

