mod export;

use export::export_impl;
use proc_macro_error::proc_macro_error;
use syn::parse_macro_input;

#[proc_macro_derive(Export, attributes(uniffiexport))]
#[proc_macro_error]
pub fn export(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
    export_impl(&parse_macro_input!(input)).into()
}
