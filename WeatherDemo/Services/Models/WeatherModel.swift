//
//  WeatherModel.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

@objcMembers class WeatherModel: NSObject {
    var id: NSNumber?
    var main: String?
    var desc: String?
    var icon: String? {
        didSet {
            iconURL = kIconURLPrefix + "\(icon ?? "")" + kIconURLTailer
        }
    }
    var iconURL: String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable: Any]! {
        return ["desc": "description"]
    }
}
