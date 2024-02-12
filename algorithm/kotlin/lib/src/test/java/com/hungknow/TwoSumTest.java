package com.hungknow;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class TwoSumTest {

    @Test
    public void testTwoSum() {
        TwoSum twoSum = new TwoSum();
        int[] nums = { 2, 7, 11, 15 };
        int target = 9;
        int[] expected = { 0, 1 };
        int[] result = twoSum.twoSum(nums, target);
        Assertions.assertArrayEquals(expected, result);
    }

    @Test
    public void testTwoSum_NoSolution() {
        TwoSum twoSum = new TwoSum();
        int[] nums = { 2, 7, 11, 15 };
        int target = 0;
        Assertions.assertThrows(IllegalArgumentException.class, () -> {
            twoSum.twoSum(nums, target);
        });
    }
}
