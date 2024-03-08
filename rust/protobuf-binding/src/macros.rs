
macro_rules! factory_tuple ({ $($param:ident)* } => {
    impl<Func, $($param,)* Res> AFPluginHandler<($($param,)*), Res> for Func
    where Func: Fn($($param),*) -> Res + Clone + 'static + ProtobufConcurrent,
          Res: Future + ProtobufConcurrent,
        //   Res::Output: AFPluginResponder,
    {
        #[allow(non_snake_case)]
        fn call(&self, ($($param,)*): ($($param,)*)) -> Res {
            (self)($($param,)*)
        }
    }
});

// factory_tuple! {}
// factory_tuple! { A }
factory_tuple! { A B }
// factory_tuple! { A B C }
// factory_tuple! { A B C D }
// factory_tuple! { A B C D E }
