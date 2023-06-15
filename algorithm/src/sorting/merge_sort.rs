fn top_down_merge_sort<T>(res: &mut [t]) {
    let m = res.len() / 2;

    merge(1, m);
    merge(m+1, n);
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
    }
}