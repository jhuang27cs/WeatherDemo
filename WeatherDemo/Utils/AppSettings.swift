//
//  AppSettings.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import UIKit

let settingsMainKey = "app_settings"

var Settings = AppSettings.instance

class AppSettings: NSObject {
    
    static let instance = AppSettings()
    
    // MARK: - Settings

    var environmentType: EnvironmentType {
        get { return EnvironmentType(rawValue: get("environmentType", defaultValue: EnvironmentType.prod.rawValue) as! String)!}
        set { set(newValue.rawValue, "environmentType") }
    }
    
    var themeSetting: AppThemeSetting {
        get { return AppThemeSetting(rawValue: get("themeSetting", defaultValue: AppThemeSetting.light.rawValue) as! Int)!}
        set { set(newValue.rawValue, "themeSetting") }
    }
    
    // default location is America/Chicago
    var latitude: Double {
        get { return get("latitude", defaultValue: 33.44) as! Double }
        set { set(newValue, "latitude") }
    }
    
    var longitude: Double {
        get { return get("longitude", defaultValue: -94.04) as! Double }
        set { set(newValue, "longitude") }
    }
    
    var weatherDic : NSDictionary? {
        get {
            var wData = NSDictionary()
            if let data = get("weatherDic", defaultValue: nil)  {
                if let wD = KeyedUnarchiver.unarchiveObject(with: data as! Data) as? NSDictionary {
                    wData =  wD
                }
            }
            return wData
        }
        set {
            let data = KeyedArchiver.archivedData(withRootObject: newValue ?? NSDictionary())
            set(data, "weatherDic")
        }
    }
    
    // MARK: - Utils
    
    var host: String {
        return host(self.environmentType)
    }
    
    var hostPath: String {
        return "https://" + self.host
    }
    
    var hostPathDataApi: String {
        return self.hostPath + "/data/2.5/"
    }
    
    // MARK: - Public
    
    func resetAllSettings() {
        if let userDefaults = UserDefaults(suiteName: "group.com.weatherdemo") {
            userDefaults.removeObject(forKey: settingsMainKey)
            userDefaults.synchronize()
        }
    }
   
    // MARK: - Private
    
    private func setArchived(_ value: Any?, _ key: String!) {
        var value = value
        if let val = value {
            value = KeyedArchiver.archivedData(withRootObject: val)
        }
        set(value, key)
    }
    
    private func getArchived(_ key: String!, defaultValue: Any?) -> Any? {
        var value = get(key, defaultValue: defaultValue)
        if let val = value as? Data {
            value = KeyedUnarchiver.unarchiveObject(with: val)
        }
        return value
    }
    
    private func set(_ value: Any?, _ key: String!) {
        if let userDefaults = UserDefaults(suiteName: "group.com.weatherdemo") {
            var settings = (userDefaults.value(forKey: settingsMainKey) as? [String: Any]) ?? [String: Any]()
            settings[key] = value
            userDefaults.set(settings, forKey: settingsMainKey)
            userDefaults.synchronize()
        }
    }
    
    private func get(_ key: String!, defaultValue: Any?) -> Any? {
        let userDefaults = UserDefaults(suiteName: "group.com.weatherdemo")
        let settings = (userDefaults?.value(forKey: settingsMainKey) as? [String: Any])
        if settings == nil {
            return defaultValue
        }
        let value = settings![key]
        if value == nil {
            return defaultValue
        }
        return value
    }
}

enum EnvironmentType: String, CaseIterable {
    case prod, beta, stage, qa
    
    func title() -> String {
        switch self {
        case .prod:                return "Production"
        case .beta:                return "Beta"
        case .stage:            return "Staging"
        case .qa:                return "QA"
        }
    }
    
    static func titles() -> [String] {
        return EnvironmentType.allCases.map { $0.title() }
    }
}


typealias ServerSettings = AppSettings

extension ServerSettings {
    func host(_ environment: EnvironmentType) -> String {
        switch environment {
        case .prod:                 return "api.openweathermap.org"
        case .beta:                 return "api.openweathermap.org"
        case .stage:                return "api.openweathermap.org"
        case .qa:                   return "api.openweathermap.org"
        }
    }
}


