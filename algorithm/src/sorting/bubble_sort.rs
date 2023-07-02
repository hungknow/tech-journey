pub fn bubble_sort<T: Ord>(arr: &mut [T]) {
    if arr.is_empty() {
        return;
    }

    let n = arr.len();
    for i in 0..n {
        let mut swap = false;
        for j in (i+1..n).rev() {
            if arr[j-1] > arr[j] {
               arr.swap(j-1, j);
               swap = true
            }
        }
        if !swap {
            break;
        }
    }
    // let mut sorted = false;
    // while !sorted {
    //     sorted = true;
    //     for i in 0..n-1 {
    //        if arr[i] > arr[i+1] {
    //         arr.swap(i, i+1);
    //         sorted = false;
    //        } 
    //     }
    //     n -= 1;
    // }

}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::sorting::is_sorted;
    use crate::sorting::have_same_elements;

    #[test]
    fn descending() {
        let mut ve1 = vec![6, 5, 4, 3, 2, 1];
        let cloned = ve1.clone();
        bubble_sort(&mut ve1);
        assert!(is_sorted(&ve1) && have_same_elements(&ve1, &cloned));
    }

    #[test]
    fn ascending() {
        //pre-sorted
        let mut ve2 = vec![1, 2, 3, 4, 5, 6];
        let cloned = ve2.clone();
        bubble_sort(&mut ve2);
        assert!(is_sorted(&ve2) && have_same_elements(&ve2, &cloned));
    }

    #[test]
    fn empty() {
        let mut vec3: Vec<usize> = vec![];
        bubble_sort(&mut vec3);
        assert!(is_sorted(&vec3));
    }

    #[test]
    fn random() {
        let mut ve4 = vec![5, 6, 3, 4, 1, 2];
        let cloned = ve4.clone();
        bubble_sort(&mut ve4);
        assert!(is_sorted(&ve4) && have_same_elements(&ve4, &cloned));
    }
}