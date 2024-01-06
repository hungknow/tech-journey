#[derive(Debug)]
struct Record {
    name: String,
    age: i32,
    phones: Vec<String> 
}

enum Status {
    Active,
    Inactive 
}

#[test]
fn test1() {
    let mut records = Vec::new();
    for i in 0..100 {
        let record = Record {
            name: format!("name{}", i),
            age: i,
            phones: vec![format!("phone{}", i)],
        };
        records.push(record);
    }
    // println!("{:?}", records);

    let v = vec![1, 2, 3, 4, 5];
    println!("sum: {}", v.iter().sum::<i32>());
    println!("iter: {}", v.iter().fold(0, |acc, &n| acc + n));
    println!("filter: {:?}", v.iter().filter(|&n| n % 2 == 0));

    // let groups = v.iter().group_by(|&n| n % 2 == 0); // Use the group_by method
    // println("groups: {:?}", groups.get(&true).unwrap());
}