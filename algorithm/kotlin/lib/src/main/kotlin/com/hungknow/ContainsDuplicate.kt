package com.hungknow.kotlin

class ContainsDuplicate {
    fun containsDuplicate(nums: IntArray): Boolean {
        return nums.size != nums.toSet().size
    }

    fun containsDuplicate2(nums: IntArray): Boolean {
        nums.sort()
        for (i in 0 until nums.size - 1) {
            if (nums[i] == nums[i + 1]) {
                return true
            }
        }
        return false
    }

    fun containsDuplicate3(nums: IntArray): Boolean {
        val set = HashSet<Int>()
        for (num in nums) {
            if (set.contains(num)) {
                return true
            }
            set.add(num)
        }
        return false
    }
}
