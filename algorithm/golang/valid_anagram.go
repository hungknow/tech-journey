package algo

func IsAnagram(s string, t string) bool {
	if len(s) != len(t) {
		return false
	}

	var sMap = make([]int, 26)
	for index := range sMap {
		sMap[index] = 0
	}

	for _, char := range s {
		sMap[char-'a']++
	}

	for _, char := range t {
		sMap[char-'a']--
	}

	for _, count := range sMap {
		if count != 0 {
			return false
		}
	}

	return true
}
