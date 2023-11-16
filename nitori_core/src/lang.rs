use std::ffi::{c_char, CString};

pub trait FFIString {
    fn cstring(&self) -> CString;
    fn cstring_ptr(&self) -> *const c_char;
}

impl FFIString for String {
    fn cstring(&self) -> CString {
        CString::new(self.clone()).unwrap()
    }

    fn cstring_ptr(&self) -> *const c_char {
        self.cstring().into_raw()
    }
}
