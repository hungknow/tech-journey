fn merge<T: Ord + Copy>(arr: &mut [T], mid: usize) {
    let left_half = arr[..mid].to_vec();
    let right_half = arr[mid..].to_vec();

    let mut l_index = 0;
    let mut r_index = 0;

    for v in arr {
        // compare the item
        if r_index == right_half.len() || (l_index < left_half.len() && left_half[l_index] < right_half[r_index]) {
            *v = left_half[l_index];
            l_index += 1;
        } else {
            *v = right_half[r_index];
            r_index += 1;
        }
    }
}

pub fn top_down_merge_sort<T: Ord + Copy>(arr: &mut [T]) {
    let arr_len = arr.len();

    if arr_len > 1 {
        let mid = arr_len / 2;

        top_down_merge_sort(&mut arr[..mid]);
        if arr_len > 2 {
            top_down_merge_sort(&mut arr[mid..]);
        }

        // merge two arrays
        merge(arr, mid);
    }
}

pub fn bottom_up_merge_sort<T>(arr: &mut [T]) {
    if arr.len() > 1 {

    }
}

#[cfg(test)]
mod tests {

    #[cfg(test)]
    mod top_down_merge_sort {
        use super::super::*;
        use crate::sorting::is_sorted;
        use crate::sorting::have_same_elements;

        #[test]
        fn basic() {
            let mut res = vec![10, 8, 4, 3, 1, 9, 2, 7, 5, 6];
            let cloned = res.clone();
            top_down_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }

        #[test]
        fn basic_string() {
            let mut res = vec!["a", "bb", "d", "cc"];
            let cloned = res.clone();
            top_down_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }

        #[test]
        fn one_element() {
            let mut res = vec![1];
            let cloned = res.clone();
            top_down_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }
    }

    #[cfg(test)]
    mod bottom_up_merge_sort {
        use super::super::*;
        use crate::sorting::is_sorted;
        use crate::sorting::have_same_elements;

        #[test]
        fn basic() {
            let mut res = vec![10, 8, 4, 3, 1, 9, 2, 7, 5, 6];
            let cloned = res.clone();
            bottom_up_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }

        #[test]
        fn basic_string() {
            let mut res = vec!["a", "bb", "d", "cc"];
            let cloned = res.clone();
            bottom_up_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }

        #[test]
        fn one_element() {
            let mut res = vec![1];
            let cloned = res.clone();
            bottom_up_merge_sort(&mut res);
            assert!(is_sorted(&res) && have_same_elements(&res, &cloned));
        }
    }
}