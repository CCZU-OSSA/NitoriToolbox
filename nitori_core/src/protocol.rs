use monitor_control_win::Monitor;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub type DATA = Vec<HashMap<String, wmi::Variant>>;
pub type DATAMAP<'a> = HashMap<&'a str, DATA>;

#[derive(Serialize, Deserialize)]
pub struct QueryArg {
    #[serde(borrow)]
    pub target: Vec<&'static str>,
}

#[derive(Serialize, Deserialize)]
pub struct MonitorInfo {
    pub driver_id: String,
    pub id: String,
}

impl MonitorInfo {
    pub fn from_monitor(monitor: &Monitor) -> Self {
        Self {
            driver_id: monitor.driver_id.clone(),
            id: monitor.id.clone(),
        }
    }
}

trait Infolize {
    type Target;
    fn to_info(&self) -> Self::Target;
}

impl Infolize for Monitor {
    type Target = MonitorInfo;

    fn to_info(&self) -> Self::Target {
        MonitorInfo::from_monitor(self)
    }
}
