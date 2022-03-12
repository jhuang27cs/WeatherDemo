//
//  DailyModel.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

@objcMembers class DailyModel: BaseDayModel {
    var moonrise: NSNumber?
    var moonset: NSNumber?
    var moonPhase: NSNumber?
    var temp: TempModel?
    var feelsLike: TempModel?
    var windGust: NSNumber?
    var weather: [WeatherModel]?
    var pop: NSNumber?
    var rain: NSNumber?
    var snow: NSNumber?
    
    // MARK: - Overridden
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return ["moonPhase": "moon_phase",
                "feelsLike": "feels_like",
                "dewPoint" : "dew_point",
                "windSpeed" : "wind_speed",
                "windDeg" : "wind_deg",
                "windGust" : "wind_gust"]
    }
   
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["weather": WeatherModel.self,
                "temp": TempModel.self,
                "feelsLike": TempModel.self]
    }
}
