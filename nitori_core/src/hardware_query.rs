use std::collections::HashMap;

use monitor_control_win::Monitor;
use wmi::{COMLibrary, WMIConnection};

use crate::protocol::{MonitorInfo, QueryArg, QueryResult, DATAMAP};

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

    let mut result: QueryResult = HashMap::new();
    result.insert("data", data);
    serde_json::to_string(&result).unwrap()
}

pub fn get_montiors() -> String {
    let monitors: Vec<MonitorInfo> = Monitor::all()
        .unwrap()
        .iter()
        .map(|v| MonitorInfo::from_monitor(v))
        .collect();
    let mut result: HashMap<&str, Vec<MonitorInfo>> = HashMap::new();
    result.insert("data", monitors);
    return serde_json::to_string(&result).unwrap();
}
