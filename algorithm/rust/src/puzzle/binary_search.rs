fn binary_search(arr: &[i32], target: i32) -> i32  {
    let mut left = 0;
    let mut right = arr.len() as i32 - 1;
    while left <= right {
        let mid = left + (right - left) / 2;
        if arr[mid as usize] == target {
            return mid;
        } else if arr[mid as usize] < target {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    -1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_binary_search() {
        let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        assert_eq!(binary_search(&arr, 5), 4);
        assert_eq!(binary_search(&arr, 10), -1);
    }
}
