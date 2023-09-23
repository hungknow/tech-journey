#[derive(Debug, PartialEq)]
struct Foo {
    bar: String
}

#[derive(Default)]
pub struct FooBuilder {
    bar: String
}

impl FooBuilder {
    pub fn new() -> FooBuilder {
        FooBuilder { 
            bar: String::from("X"),
        }
    }

    pub fn name(mut self, bar: String) -> FooBuilder {
        self.bar = bar;
        self
    }

    pub fn build(self) -> Foo {
        Foo { bar: self.bar }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn builder_test() {
        let foo = Foo {
            bar: String::from("Y")
        };

        let foo_from_builder: Foo = FooBuilder::new().name(String::from("Y")).build();
        assert_eq!(foo, foo_from_builder)
    }
}