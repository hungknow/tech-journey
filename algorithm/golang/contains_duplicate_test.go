package algo_test

import (
	"testing"

	"hungknow.com/algo"
)

func TestContainsDuplicate(t *testing.T) {
	t.Parallel()
	tests := []struct {
		name     string
		nums     []int
		expected bool
	}{
		{"short array, contains", []int{1, 2, 3, 1}, true},
		{"not contains duplicate", []int{1, 2, 3, 4}, false},
		{"not contains duplicate", []int{1, 1, 1, 3, 3, 4, 3, 2, 4, 2}, true},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual := algo.ContainsDuplicate(tt.nums)
			if actual != tt.expected {
				t.Errorf("expected %v, but got %v", tt.expected, actual)
			}

			actual2 := algo.ContainsDuplicate2(tt.nums)
			if actual2 != tt.expected {
				t.Errorf("expected %v, but got %v", tt.expected, actual2)
			}

			actual3 := algo.ContainsDuplicate3(tt.nums)
			if actual3 != tt.expected {
				t.Errorf("expected %v, but got %v", tt.expected, actual2)
			}
		})
	}
}
