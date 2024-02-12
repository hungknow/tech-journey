package com.hungknow

import kotlin.test.Test
import kotlin.test.assertContentEquals

class TwoSumTest {
    @Test fun testTwoSum() {
        val nums = intArrayOf(2, 7, 11, 15)
        val target = 9
        val result = twoSum(nums, target)
        assertContentEquals(intArrayOf(0, 1), result)
    }
}
