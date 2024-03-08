// This file is generated by rust-protobuf 3.4.0. Do not edit
// .proto file is parsed by protoc 25.3
// @generated

// https://github.com/rust-lang/rust-clippy/issues/702
#![allow(unknown_lints)]
#![allow(clippy::all)]

#![allow(unused_attributes)]
#![cfg_attr(rustfmt, rustfmt::skip)]

#![allow(box_pointers)]
#![allow(dead_code)]
#![allow(missing_docs)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(non_upper_case_globals)]
#![allow(trivial_casts)]
#![allow(unused_results)]
#![allow(unused_mut)]

//! Generated file from `errors.proto`

/// Generated files are compatible only with the same version
/// of protobuf runtime.
const _PROTOBUF_VERSION_CHECK: () = ::protobuf::VERSION_3_4_0;

// @@protoc_insertion_point(message:FlowyError)
#[derive(PartialEq,Clone,Default,Debug)]
pub struct FlowyError {
    // message fields
    // @@protoc_insertion_point(field:FlowyError.code)
    pub code: ::protobuf::EnumOrUnknown<ErrorCode>,
    // @@protoc_insertion_point(field:FlowyError.msg)
    pub msg: ::std::string::String,
    // @@protoc_insertion_point(field:FlowyError.payload)
    pub payload: ::std::vec::Vec<u8>,
    // special fields
    // @@protoc_insertion_point(special_field:FlowyError.special_fields)
    pub special_fields: ::protobuf::SpecialFields,
}

impl<'a> ::std::default::Default for &'a FlowyError {
    fn default() -> &'a FlowyError {
        <FlowyError as ::protobuf::Message>::default_instance()
    }
}

impl FlowyError {
    pub fn new() -> FlowyError {
        ::std::default::Default::default()
    }

    fn generated_message_descriptor_data() -> ::protobuf::reflect::GeneratedMessageDescriptorData {
        let mut fields = ::std::vec::Vec::with_capacity(3);
        let mut oneofs = ::std::vec::Vec::with_capacity(0);
        fields.push(::protobuf::reflect::rt::v2::make_simpler_field_accessor::<_, _>(
            "code",
            |m: &FlowyError| { &m.code },
            |m: &mut FlowyError| { &mut m.code },
        ));
        fields.push(::protobuf::reflect::rt::v2::make_simpler_field_accessor::<_, _>(
            "msg",
            |m: &FlowyError| { &m.msg },
            |m: &mut FlowyError| { &mut m.msg },
        ));
        fields.push(::protobuf::reflect::rt::v2::make_simpler_field_accessor::<_, _>(
            "payload",
            |m: &FlowyError| { &m.payload },
            |m: &mut FlowyError| { &mut m.payload },
        ));
        ::protobuf::reflect::GeneratedMessageDescriptorData::new_2::<FlowyError>(
            "FlowyError",
            fields,
            oneofs,
        )
    }
}

impl ::protobuf::Message for FlowyError {
    const NAME: &'static str = "FlowyError";

    fn is_initialized(&self) -> bool {
        true
    }

    fn merge_from(&mut self, is: &mut ::protobuf::CodedInputStream<'_>) -> ::protobuf::Result<()> {
        while let Some(tag) = is.read_raw_tag_or_eof()? {
            match tag {
                8 => {
                    self.code = is.read_enum_or_unknown()?;
                },
                18 => {
                    self.msg = is.read_string()?;
                },
                26 => {
                    self.payload = is.read_bytes()?;
                },
                tag => {
                    ::protobuf::rt::read_unknown_or_skip_group(tag, is, self.special_fields.mut_unknown_fields())?;
                },
            };
        }
        ::std::result::Result::Ok(())
    }

    // Compute sizes of nested messages
    #[allow(unused_variables)]
    fn compute_size(&self) -> u64 {
        let mut my_size = 0;
        if self.code != ::protobuf::EnumOrUnknown::new(ErrorCode::Internal) {
            my_size += ::protobuf::rt::int32_size(1, self.code.value());
        }
        if !self.msg.is_empty() {
            my_size += ::protobuf::rt::string_size(2, &self.msg);
        }
        if !self.payload.is_empty() {
            my_size += ::protobuf::rt::bytes_size(3, &self.payload);
        }
        my_size += ::protobuf::rt::unknown_fields_size(self.special_fields.unknown_fields());
        self.special_fields.cached_size().set(my_size as u32);
        my_size
    }

    fn write_to_with_cached_sizes(&self, os: &mut ::protobuf::CodedOutputStream<'_>) -> ::protobuf::Result<()> {
        if self.code != ::protobuf::EnumOrUnknown::new(ErrorCode::Internal) {
            os.write_enum(1, ::protobuf::EnumOrUnknown::value(&self.code))?;
        }
        if !self.msg.is_empty() {
            os.write_string(2, &self.msg)?;
        }
        if !self.payload.is_empty() {
            os.write_bytes(3, &self.payload)?;
        }
        os.write_unknown_fields(self.special_fields.unknown_fields())?;
        ::std::result::Result::Ok(())
    }

    fn special_fields(&self) -> &::protobuf::SpecialFields {
        &self.special_fields
    }

    fn mut_special_fields(&mut self) -> &mut ::protobuf::SpecialFields {
        &mut self.special_fields
    }

    fn new() -> FlowyError {
        FlowyError::new()
    }

    fn clear(&mut self) {
        self.code = ::protobuf::EnumOrUnknown::new(ErrorCode::Internal);
        self.msg.clear();
        self.payload.clear();
        self.special_fields.clear();
    }

    fn default_instance() -> &'static FlowyError {
        static instance: FlowyError = FlowyError {
            code: ::protobuf::EnumOrUnknown::from_i32(0),
            msg: ::std::string::String::new(),
            payload: ::std::vec::Vec::new(),
            special_fields: ::protobuf::SpecialFields::new(),
        };
        &instance
    }
}

impl ::protobuf::MessageFull for FlowyError {
    fn descriptor() -> ::protobuf::reflect::MessageDescriptor {
        static descriptor: ::protobuf::rt::Lazy<::protobuf::reflect::MessageDescriptor> = ::protobuf::rt::Lazy::new();
        descriptor.get(|| file_descriptor().message_by_package_relative_name("FlowyError").unwrap()).clone()
    }
}

impl ::std::fmt::Display for FlowyError {
    fn fmt(&self, f: &mut ::std::fmt::Formatter<'_>) -> ::std::fmt::Result {
        ::protobuf::text_format::fmt(self, f)
    }
}

impl ::protobuf::reflect::ProtobufValue for FlowyError {
    type RuntimeType = ::protobuf::reflect::rt::RuntimeTypeMessage<Self>;
}

#[derive(Clone,Copy,PartialEq,Eq,Debug,Hash)]
// @@protoc_insertion_point(enum:ErrorCode)
pub enum ErrorCode {
    // @@protoc_insertion_point(enum_value:ErrorCode.Internal)
    Internal = 0,
    // @@protoc_insertion_point(enum_value:ErrorCode.UserUnauthorized)
    UserUnauthorized = 2,
    // @@protoc_insertion_point(enum_value:ErrorCode.RecordNotFound)
    RecordNotFound = 3,
    // @@protoc_insertion_point(enum_value:ErrorCode.UserIdIsEmpty)
    UserIdIsEmpty = 4,
    // @@protoc_insertion_point(enum_value:ErrorCode.WorkspaceNameInvalid)
    WorkspaceNameInvalid = 5,
    // @@protoc_insertion_point(enum_value:ErrorCode.WorkspaceDescTooLong)
    WorkspaceDescTooLong = 8,
    // @@protoc_insertion_point(enum_value:ErrorCode.WorkspaceNameTooLong)
    WorkspaceNameTooLong = 9,
    // @@protoc_insertion_point(enum_value:ErrorCode.WorkspaceInitializeError)
    WorkspaceInitializeError = 6,
    // @@protoc_insertion_point(enum_value:ErrorCode.ViewNameInvalid)
    ViewNameInvalid = 12,
    // @@protoc_insertion_point(enum_value:ErrorCode.ViewThumbnailInvalid)
    ViewThumbnailInvalid = 13,
    // @@protoc_insertion_point(enum_value:ErrorCode.ViewIdIsInvalid)
    ViewIdIsInvalid = 14,
    // @@protoc_insertion_point(enum_value:ErrorCode.ViewDataInvalid)
    ViewDataInvalid = 16,
    // @@protoc_insertion_point(enum_value:ErrorCode.ViewNameTooLong)
    ViewNameTooLong = 17,
    // @@protoc_insertion_point(enum_value:ErrorCode.EmailIsEmpty)
    EmailIsEmpty = 19,
    // @@protoc_insertion_point(enum_value:ErrorCode.EmailFormatInvalid)
    EmailFormatInvalid = 20,
}

impl ::protobuf::Enum for ErrorCode {
    const NAME: &'static str = "ErrorCode";

    fn value(&self) -> i32 {
        *self as i32
    }

    fn from_i32(value: i32) -> ::std::option::Option<ErrorCode> {
        match value {
            0 => ::std::option::Option::Some(ErrorCode::Internal),
            2 => ::std::option::Option::Some(ErrorCode::UserUnauthorized),
            3 => ::std::option::Option::Some(ErrorCode::RecordNotFound),
            4 => ::std::option::Option::Some(ErrorCode::UserIdIsEmpty),
            5 => ::std::option::Option::Some(ErrorCode::WorkspaceNameInvalid),
            8 => ::std::option::Option::Some(ErrorCode::WorkspaceDescTooLong),
            9 => ::std::option::Option::Some(ErrorCode::WorkspaceNameTooLong),
            6 => ::std::option::Option::Some(ErrorCode::WorkspaceInitializeError),
            12 => ::std::option::Option::Some(ErrorCode::ViewNameInvalid),
            13 => ::std::option::Option::Some(ErrorCode::ViewThumbnailInvalid),
            14 => ::std::option::Option::Some(ErrorCode::ViewIdIsInvalid),
            16 => ::std::option::Option::Some(ErrorCode::ViewDataInvalid),
            17 => ::std::option::Option::Some(ErrorCode::ViewNameTooLong),
            19 => ::std::option::Option::Some(ErrorCode::EmailIsEmpty),
            20 => ::std::option::Option::Some(ErrorCode::EmailFormatInvalid),
            _ => ::std::option::Option::None
        }
    }

    fn from_str(str: &str) -> ::std::option::Option<ErrorCode> {
        match str {
            "Internal" => ::std::option::Option::Some(ErrorCode::Internal),
            "UserUnauthorized" => ::std::option::Option::Some(ErrorCode::UserUnauthorized),
            "RecordNotFound" => ::std::option::Option::Some(ErrorCode::RecordNotFound),
            "UserIdIsEmpty" => ::std::option::Option::Some(ErrorCode::UserIdIsEmpty),
            "WorkspaceNameInvalid" => ::std::option::Option::Some(ErrorCode::WorkspaceNameInvalid),
            "WorkspaceDescTooLong" => ::std::option::Option::Some(ErrorCode::WorkspaceDescTooLong),
            "WorkspaceNameTooLong" => ::std::option::Option::Some(ErrorCode::WorkspaceNameTooLong),
            "WorkspaceInitializeError" => ::std::option::Option::Some(ErrorCode::WorkspaceInitializeError),
            "ViewNameInvalid" => ::std::option::Option::Some(ErrorCode::ViewNameInvalid),
            "ViewThumbnailInvalid" => ::std::option::Option::Some(ErrorCode::ViewThumbnailInvalid),
            "ViewIdIsInvalid" => ::std::option::Option::Some(ErrorCode::ViewIdIsInvalid),
            "ViewDataInvalid" => ::std::option::Option::Some(ErrorCode::ViewDataInvalid),
            "ViewNameTooLong" => ::std::option::Option::Some(ErrorCode::ViewNameTooLong),
            "EmailIsEmpty" => ::std::option::Option::Some(ErrorCode::EmailIsEmpty),
            "EmailFormatInvalid" => ::std::option::Option::Some(ErrorCode::EmailFormatInvalid),
            _ => ::std::option::Option::None
        }
    }

    const VALUES: &'static [ErrorCode] = &[
        ErrorCode::Internal,
        ErrorCode::UserUnauthorized,
        ErrorCode::RecordNotFound,
        ErrorCode::UserIdIsEmpty,
        ErrorCode::WorkspaceNameInvalid,
        ErrorCode::WorkspaceDescTooLong,
        ErrorCode::WorkspaceNameTooLong,
        ErrorCode::WorkspaceInitializeError,
        ErrorCode::ViewNameInvalid,
        ErrorCode::ViewThumbnailInvalid,
        ErrorCode::ViewIdIsInvalid,
        ErrorCode::ViewDataInvalid,
        ErrorCode::ViewNameTooLong,
        ErrorCode::EmailIsEmpty,
        ErrorCode::EmailFormatInvalid,
    ];
}

impl ::protobuf::EnumFull for ErrorCode {
    fn enum_descriptor() -> ::protobuf::reflect::EnumDescriptor {
        static descriptor: ::protobuf::rt::Lazy<::protobuf::reflect::EnumDescriptor> = ::protobuf::rt::Lazy::new();
        descriptor.get(|| file_descriptor().enum_by_package_relative_name("ErrorCode").unwrap()).clone()
    }

    fn descriptor(&self) -> ::protobuf::reflect::EnumValueDescriptor {
        let index = match self {
            ErrorCode::Internal => 0,
            ErrorCode::UserUnauthorized => 1,
            ErrorCode::RecordNotFound => 2,
            ErrorCode::UserIdIsEmpty => 3,
            ErrorCode::WorkspaceNameInvalid => 4,
            ErrorCode::WorkspaceDescTooLong => 5,
            ErrorCode::WorkspaceNameTooLong => 6,
            ErrorCode::WorkspaceInitializeError => 7,
            ErrorCode::ViewNameInvalid => 8,
            ErrorCode::ViewThumbnailInvalid => 9,
            ErrorCode::ViewIdIsInvalid => 10,
            ErrorCode::ViewDataInvalid => 11,
            ErrorCode::ViewNameTooLong => 12,
            ErrorCode::EmailIsEmpty => 13,
            ErrorCode::EmailFormatInvalid => 14,
        };
        Self::enum_descriptor().value_by_index(index)
    }
}

impl ::std::default::Default for ErrorCode {
    fn default() -> Self {
        ErrorCode::Internal
    }
}

impl ErrorCode {
    fn generated_enum_descriptor_data() -> ::protobuf::reflect::GeneratedEnumDescriptorData {
        ::protobuf::reflect::GeneratedEnumDescriptorData::new::<ErrorCode>("ErrorCode")
    }
}

static file_descriptor_proto_data: &'static [u8] = b"\
    \n\x0cerrors.proto\"X\n\nFlowyError\x12\x1e\n\x04code\x18\x01\x20\x01(\
    \x0e2\n.ErrorCodeR\x04code\x12\x10\n\x03msg\x18\x02\x20\x01(\tR\x03msg\
    \x12\x18\n\x07payload\x18\x03\x20\x01(\x0cR\x07payload*\xda\x02\n\tError\
    Code\x12\x0c\n\x08Internal\x10\0\x12\x14\n\x10UserUnauthorized\x10\x02\
    \x12\x12\n\x0eRecordNotFound\x10\x03\x12\x11\n\rUserIdIsEmpty\x10\x04\
    \x12\x18\n\x14WorkspaceNameInvalid\x10\x05\x12\x18\n\x14WorkspaceDescToo\
    Long\x10\x08\x12\x18\n\x14WorkspaceNameTooLong\x10\t\x12\x1c\n\x18Worksp\
    aceInitializeError\x10\x06\x12\x13\n\x0fViewNameInvalid\x10\x0c\x12\x18\
    \n\x14ViewThumbnailInvalid\x10\r\x12\x13\n\x0fViewIdIsInvalid\x10\x0e\
    \x12\x13\n\x0fViewDataInvalid\x10\x10\x12\x13\n\x0fViewNameTooLong\x10\
    \x11\x12\x10\n\x0cEmailIsEmpty\x10\x13\x12\x16\n\x12EmailFormatInvalid\
    \x10\x14b\x06proto3\
";

/// `FileDescriptorProto` object which was a source for this generated file
fn file_descriptor_proto() -> &'static ::protobuf::descriptor::FileDescriptorProto {
    static file_descriptor_proto_lazy: ::protobuf::rt::Lazy<::protobuf::descriptor::FileDescriptorProto> = ::protobuf::rt::Lazy::new();
    file_descriptor_proto_lazy.get(|| {
        ::protobuf::Message::parse_from_bytes(file_descriptor_proto_data).unwrap()
    })
}

/// `FileDescriptor` object which allows dynamic access to files
pub fn file_descriptor() -> &'static ::protobuf::reflect::FileDescriptor {
    static generated_file_descriptor_lazy: ::protobuf::rt::Lazy<::protobuf::reflect::GeneratedFileDescriptor> = ::protobuf::rt::Lazy::new();
    static file_descriptor: ::protobuf::rt::Lazy<::protobuf::reflect::FileDescriptor> = ::protobuf::rt::Lazy::new();
    file_descriptor.get(|| {
        let generated_file_descriptor = generated_file_descriptor_lazy.get(|| {
            let mut deps = ::std::vec::Vec::with_capacity(0);
            let mut messages = ::std::vec::Vec::with_capacity(1);
            messages.push(FlowyError::generated_message_descriptor_data());
            let mut enums = ::std::vec::Vec::with_capacity(1);
            enums.push(ErrorCode::generated_enum_descriptor_data());
            ::protobuf::reflect::GeneratedFileDescriptor::new_generated(
                file_descriptor_proto(),
                deps,
                messages,
                enums,
            )
        });
        ::protobuf::reflect::FileDescriptor::new_generated_2(generated_file_descriptor)
    })
}
