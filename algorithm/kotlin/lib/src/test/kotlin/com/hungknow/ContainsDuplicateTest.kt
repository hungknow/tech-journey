package com.hungknow.kotlin

import kotlin.test.Test
import kotlin.test.assertEquals

class ContainsDuplicateTest {
    @Test
    fun containsDuplicate() {
        val testcases =
                arrayOf(
                        intArrayOf(1, 2, 3, 1) to true,
                        intArrayOf(1, 2, 3, 4) to false,
                        intArrayOf(11, 1, 1, 3, 3, 4, 3, 2, 4, 2) to true
                )
        val containsDuplicate = ContainsDuplicate()
        for (testcase in testcases) {
            val input = testcase.first
            val expected = testcase.second
            assertEquals(expected, containsDuplicate.containsDuplicate(input))
            assertEquals(expected, containsDuplicate.containsDuplicate2(input))
            assertEquals(expected, containsDuplicate.containsDuplicate3(input))
        }
    }
}
