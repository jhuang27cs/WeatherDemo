//
//  OneCallAPIResponseModel.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

@objcMembers class OneCallAPIResponseModel: NSObject {
    var lat: NSNumber?
    var lon: NSNumber?
    var timezone: String?
    var timezoneOffset: NSNumber?
    var current: CurrentModel?
    var daily: [DailyModel]?
    
    // MARK: - Overridden
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return ["timezoneOffset": "timezone_offset"]
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["current": CurrentModel.self, "daily" : DailyModel.self]
    }
}

