use pipelines::Pipeline;


/*
  A -> B -> C -> D
       \-> B1 --/
 */
struct A {}
struct B {}
struct C {}
struct D {}
struct B1 {}
fn fibonacci(n:u64)->u64{if n<2 {1} else {fibonacci(n-1) + fibonacci(n-2)}}


#[test]
fn testPipeline() {
    let nums: Vec<u64> = (0..10).collect();
    let fibs: Vec<u64> = Pipeline::from(nums)
        .map(fibonacci)
        .into_iter().collect();
    println!("fibonacci: {:?}", fibs);

    let workers = 2;

    let nums1: Vec<u64> = (0..10).collect();
    Pipeline::from(nums1)
        .pmap(workers, fibonacci)
        .map(|x| x * 2);
}

#[test]
fn test1() {
    let a = A {};
    let b = B {};
    let c = C {};
    let d = D {};
    let b1 = B1 {};

    // let mut pipe = Pipe::new();
    // pipe.add(Box::new(a))
    //     .add(Box::new(b))
    //     .add(Box::new(c))
    //     .add(Box::new(d))
    //     .add(Box::new(b1));

    // pipe.run();
}