//
//  BaseDayModel.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

@objcMembers class BaseDayModel: NSObject {
    var dt: NSNumber?
    var sunrise: NSNumber?
    var sunset: NSNumber?
    var pressure: NSNumber?
    var humidity: NSNumber?
    var dewPoint: NSNumber?
    var clouds: NSNumber?
    var uvi: NSNumber?
    var windSpeed: NSNumber?
    var windDeg: NSNumber?
}
