package algo

import "sort"

func ContainsDuplicate(nums []int) bool {
	set := make(map[int]bool)
	for _, num := range nums {
		set[num] = true
	}
	return len(nums) != len(set)
}

func ContainsDuplicate2(nums []int) bool {
	sort.Ints(nums)
	for i := 1; i < len(nums); i++ {
		if nums[i] == nums[i-1] {
			return true
		}
	}
	return false
}

func ContainsDuplicate3(nums []int) bool {
	m := make(map[int]bool)
	for _, v := range nums {
		if m[v] {
			return true
		}
		m[v] = true
	}
	return false
}
