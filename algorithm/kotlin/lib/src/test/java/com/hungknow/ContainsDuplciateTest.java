package com.hungknow;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class ContainsDuplciateTest {
    class testCase {
        int[] nums;
        boolean expected;

        testCase(int[] nums, boolean expected) {
            this.nums = nums;
            this.expected = expected;
        }
    }

    @Test
    public void testContainsDuplicate() {
        ContainsDuplicate containsDuplicate = new ContainsDuplicate();
        testCase[] testCases = new testCase[] {
                new testCase(new int[] { 1, 2, 3, 1 }, true),
                new testCase(new int[] { 1, 2, 3, 4 }, false),
                new testCase(new int[] { 1, 1, 1, 3, 3, 4, 3, 2, 4, 2 }, true)
        };

        for (testCase tc : testCases) {
            assertEquals(containsDuplicate.containsDuplicate(tc.nums), tc.expected);
            assertEquals(containsDuplicate.containsDuplicate2(tc.nums), tc.expected);
            assertEquals(containsDuplicate.containsDuplicate3(tc.nums), tc.expected);
        }
    }
}
