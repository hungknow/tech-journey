package algo

func TwoSum(nums []int, target int) []int {
	m := make(map[int]int, 0)
	for i, v := range nums {
		if j, ok := m[target-v]; ok {
			return []int{j, i}
		} else {
			m[v] = i
		}
	}
	return nil
}
