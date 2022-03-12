//
//  CurrentModel.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

@objcMembers class CurrentModel: BaseDayModel {
    var temp: NSNumber?
    var feelsLike: NSNumber?
    var visibility: NSNumber?
    var weather: [WeatherModel]?

    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return ["dewPoint": "dew_point",
                "windSpeed": "wind_speed",
                "windDeg": "wind_deg",
                "feelsLike": "feels_like"]
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["weather": WeatherModel.self]
    }
}
