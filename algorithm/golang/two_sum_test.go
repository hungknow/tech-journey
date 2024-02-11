package algo_test

import (
	"testing"

	"hungknow.com/algo"
)

func TestTwoSum(t *testing.T) {
	nums := []int{2, 7, 11, 15}
	target := 9
	expected := []int{0, 1}

	result := algo.TwoSum(nums, target)

	if len(result) != len(expected) {
		t.Errorf("Expected length of result to be %d, but got %d", len(expected), len(result))
	}

	for i := 0; i < len(result); i++ {
		if result[i] != expected[i] {
			t.Errorf("Expected result[%d] to be %d, but got %d", i, expected[i], result[i])
		}
	}
}

func TestTwoSum_EmptyInput(t *testing.T) {
	nums := []int{}
	target := 9
	expected := []int{}

	result := algo.TwoSum(nums, target)

	if len(result) != len(expected) {
		t.Errorf("Expected length of result to be %d, but got %d", len(expected), len(result))
	}
}

func TestTwoSum_NoSolution(t *testing.T) {
	nums := []int{2, 7, 11, 15}
	target := 100
	expected := []int{}

	result := algo.TwoSum(nums, target)

	if len(result) != len(expected) {
		t.Errorf("Expected length of result to be %d, but got %d", len(expected), len(result))
	}

}
