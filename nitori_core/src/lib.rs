use std::ffi::{c_char, CStr};

pub mod hardware_query;

#[no_mangle]
pub extern "C" fn generate_info(pathto: *const c_char) {
    hardware_query::generate_info_in(unsafe {
        CStr::from_ptr(pathto)
            .to_string_lossy()
            .to_string()
            .as_str()
    })
}

#[no_mangle]
pub extern "C" fn make_info_name(name: *const c_char, pathto: *const c_char) {
    hardware_query::make_info_name_in(
        unsafe { CStr::from_ptr(name).to_string_lossy().to_string().as_str() },
        unsafe {
            CStr::from_ptr(pathto)
                .to_string_lossy()
                .to_string()
                .as_str()
        },
    )
}

#[no_mangle]
pub extern "C" fn version() -> *const u8 {
    "1.0.0 Preview".as_ptr()
}
