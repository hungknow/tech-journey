fn is_sorted<T>(arr: &[T], len: usize) -> bool {
    for i in 0..len - 1 {
        if arr[i] > arr[i + 1] {
            return false;
        }
    }

    true
}