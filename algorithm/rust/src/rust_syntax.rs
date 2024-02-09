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

use std::{time::Duration, fs::OpenOptions, sync::{Arc, Mutex, mpsc}, thread::{self, sleep}};

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

#[test]
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

fn s_closure_return<F: Fn(i32) -> i32>(x: i32, f: F) -> i32 {
    f(x) + f(x)
}

#[test]
fn test_s_closure_return() {
    assert_eq!(s_closure_return(5, |x| x + 1), 12);
}

/***
 * Sync + Send
 */
// Sync: It's safe to move a &T across a thread boundary.
// Send: It's safe to move a T across a thread boundary.

#[test]
fn test_arc_mutex() {
    let data = Arc::new(Mutex::new(vec![1, 2, 3]));

    let (tx, rx) = mpsc::channel();

    for i in 0..2 {
        let (data, tx) = (data.clone(), tx.clone());
        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            data[0] += i;
            tx.send(());
        });
    }

    for i in 0..2 {
        rx.recv();
    } 
}

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

 #[test]
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

/**
 * Pointer
 */
fn s_box_return(i: &i32) -> i32 {
    *i + 1
}

fn s_box_change(i: &mut i32) {
    *i = *i + 1
}

#[test]
fn s_box() {
    let mut x = Box::new(5);

    println!("x: {}", x);
    println!("s_box_return: {}", s_box_return(&x));
    s_box_change(&mut x);
    println!("s_box_return: {}", *x);
}

/**
 * Lifetime
 */
struct LifetimeFoo<'a> {
    x: &'a i32,
}

#[test]
fn s_lifetime() {
    let y = &5;
    let f = LifetimeFoo { x: y };
    println!("f.x: {}", f.x)
}

struct Car {
    name: String,
}

struct Wheel<'a> {
    size: i32,
    owner: &'a Car,
}

#[test]
fn test_car_lifetime() {
    let car = Car { name: "DeLorean".to_string() };

    for _ in 0..4 {
        Wheel { size: 360, owner: &car };
    }
}

#[test]
fn test_switch() {
    enum OptionValue {
        Some(i32),
        None
    }
    let optionValue = OptionValue::Some(5);
    match optionValue {
        OptionValue::Some(x) if x > 5 => println!("x > 5: {}", x),
        OptionValue::Some(x) => println!("x: {}", x),
        OptionValue::None => println!("None")
    }
}
