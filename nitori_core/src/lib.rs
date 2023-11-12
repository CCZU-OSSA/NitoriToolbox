use std::ffi::{c_char, CStr, CString};

pub mod hardware_query;
pub mod protocol;

#[no_mangle]
pub extern "C" fn version() -> *const c_char {
    CString::new("1.0.0-Preview.2").unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn query(target: *const c_char) -> *const c_char {
    CString::new(hardware_query::query(unsafe {
        CStr::from_ptr(target).to_str().unwrap()
    }))
    .unwrap()
    .into_raw()
}

#[no_mangle]
pub extern "C" fn get_montiors() -> *const c_char {
    CString::new(hardware_query::get_montiors())
        .unwrap()
        .into_raw()
}

#[cfg(test)]
mod test {
    use crate::hardware_query::{self, get_montiors};
    #[test]
    fn test_query() {
        println!(
            "{}",
            hardware_query::query("{\"target\":[\"Win32_Processor\",\"Win32_BaseBoard\"]}")
        );
    }

    #[test]
    fn test_edid() {
        println!("{}", get_montiors())
    }
}
