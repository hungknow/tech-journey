fn contains_duplicate(nums: Vec<i32>) -> bool {
    let mut set = std::collections::HashSet::new();
    for &num in &nums {
        set.insert(num);
    }
    nums.len() != set.len()
}

fn contains_duplicate2(nums: Vec<i32>) -> bool {
    let mut clone = nums.clone();
    clone.sort();
    for i in 0..clone.len() - 1 {
        if clone[i] == clone[i + 1] {
            return true;
        }
    }
    false
}

fn contains_duplicate3(nums: Vec<i32>) -> bool {
    use std::collections::HashSet;
    let mut set = HashSet::new();
    for num in nums {
        if set.contains(&num) {
            return true;
        }
        set.insert(num);
    }
    false
}

#[test]
fn test_contains_duplicate() {
    let test_cases = vec![
        (vec![1, 2, 3, 1], true),
        (vec![1, 2, 3, 4], false),
        (vec![1, 1, 1, 3, 3, 4, 3, 2, 4, 2], true),
    ];

    for (nums, expected) in test_cases {
        assert_eq!(contains_duplicate(nums.clone()), expected);
        assert_eq!(contains_duplicate2(nums.clone()), expected);
        assert_eq!(contains_duplicate3(nums.clone()), expected);
    }
}