use std::ffi::{c_char, CStr};

pub mod hardware_query;
pub mod protocol;

#[no_mangle]
pub extern "C" fn version() -> *const u8 {
    "1.0.0 Preview".as_ptr()
}

#[no_mangle]
pub extern "C" fn query(target: *const c_char) -> *const u8 {
    hardware_query::query(unsafe { CStr::from_ptr(target).to_str().unwrap() }).as_ptr()
}

#[cfg(test)]
mod test {
    use crate::hardware_query;

    #[test]
    fn test_query() {
        println!(
            "{}",
            hardware_query::query("{\"target\":[\"Win32_Processor\",\"Win32_BaseBoard\"]}")
        );
    }
}
