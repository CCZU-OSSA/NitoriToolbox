use std::collections::HashMap;

use monitor_control_win::Monitor;
use serde::Serialize;
use wmi::{COMLibrary, WMIConnection};

use crate::protocol::{MonitorInfo, QueryArg, DATAMAP};

pub fn custom_query(target: &'static str) -> String {
    let con = COMLibrary::new().unwrap();
    let wmi = WMIConnection::new(con).unwrap();
    let mut data: DATAMAP = HashMap::new();
    serde_json::from_str::<QueryArg>(target)
        .unwrap()
        .target
        .iter()
        .for_each(|t| {
            data.insert(t, wmi.raw_query(t).unwrap());
        });

    datalize(data)
}


pub fn query(target: &'static str) -> String {
    let con = COMLibrary::new().unwrap();
    let wmi = WMIConnection::new(con).unwrap();
    let mut data: DATAMAP = HashMap::new();
    serde_json::from_str::<QueryArg>(target)
        .unwrap()
        .target
        .iter()
        .for_each(|t| {
            data.insert(t, wmi.raw_query(format!("SELECT * FROM {}", t)).unwrap());
        });
    
    datalize(data)
}
pub fn get_montiors() -> String {
    let monitors: Vec<MonitorInfo> = Monitor::all()
        .unwrap()
        .iter()
        .map(|v| MonitorInfo::from_monitor(v))
        .collect();

    datalize(monitors)
}

pub fn datalize<T: Serialize>(v: T) -> String {
    let mut result: HashMap<&str, T> = HashMap::new();
    result.insert("data", v);
    serde_json::to_string(&result).unwrap()
}
