// The file that contains the Rust example code

fn s_iterator() {
    let iter1 = [1, 2, 3];

    iter1.iter().filter(|&x| *x > 1).for_each(|x| println!("iter1: {}", x));
}

#[test]
fn test_s_iterator() {
    s_iterator();
}

/***
 * Move
 */

use std::time::Duration;

fn s_move() {
    let data = vec![1, 2, 3];
    // data is no longer availabe, it's owned by closure
    let closure = move || println!("captured {data:?} by value");

    let data = vec![4, 5, 6];
    std::thread::spawn(move || println!("thread owns data: {data:?}"))
        .join()
        .unwrap();

    let capture = "hello".to_owned();
    let block = async move { println!("rust says {capture} from async block") };
}

#[test]
fn test_move() {
    s_move();
}

/***
 * Closure
 */

fn s_closure() {
    let list = vec![1, 2, 3];

    let borrowList = || println!("borrow list: {:?}", list);

    println!("before: {:?}", list);
    borrowList();
    println!("after: {:?}", list);
    borrowList();

    let mut mutableList = vec![1, 2, 3];

    println!("before: {:?}", mutableList);

    let mut borrowMutableList = || {
        mutableList.push(4);
        println!("borrow mutable list: {:?}", mutableList);
    };

    borrowMutableList();
    println!("after: {:?}", mutableList);

    let list1 = vec![1, 2, 3];

    println!("before: {:?}", list1); 
    let moveClosure = move || println!("move list: {:?}", list1);
    moveClosure();
    // println!("after: {:?}", list1);
}

#[test]
fn test_s_closure() {
    s_closure();
}

/***
 * Sync + Send
 */
// Sync: It's safe to move a &T across a thread boundary.
// Send: It's safe to move a T across a thread boundary.

/***
 * Time
 */
fn s_timer() {
    use std::time::{Instant, UNIX_EPOCH};
    let now = Instant::now();
    println!("now: {:?}", now);
    println!("now elapsed: {:?}", now.elapsed());

    // Convert epoch to time
    let epochTime = 1524820690;
    let d = UNIX_EPOCH + Duration::from_secs(epochTime);
    println!("now elapsed since {:?}", d.elapsed().unwrap());
}

#[test]
fn test_s_timer() {
    s_timer();
}

/**
 * Array 
 */

fn s_slice() {
    let mut arr = [0, 1, 2, 3, 4, 5, 6];
    // Multiple slice of the same array
    let slice1 = &arr[1..3];
    let slice2 = &arr[3..];
    println!("slice1: {:?}", slice1);
    println!("slice2: {:?}", slice2);

    // multiple slice
    let mutSlice1 = &mut arr[1..3];
    // let mutSlice2 = &mut arr[3..];
    mutSlice1[0] = 100;
    println!("mutSlice1: {:?}", arr);
    // Reset array
    arr[1] = 1;
    println!("arr: {:?}", arr);
}

#[test]
fn test_s_slice() {
    s_slice()
}
