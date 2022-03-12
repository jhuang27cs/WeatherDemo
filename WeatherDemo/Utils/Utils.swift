//
//  Utils.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import UIKit

typealias ConfirmationBlock = (_ isOK: Bool) -> Void
typealias CompletionBlock = () -> Void

class Utils: NSObject {
    
    static let sharedInstance = Utils()

    // MARK: - Public
    
    class func appVersion() -> String {
        let appVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let version = appVersionString + " (\(buildVersion))"
        return version
    }
    
    class func getSystemVersion() -> String {
        let currentDevice = UIDevice.current
        return currentDevice.systemVersion
    }
    
    class func getAppName() -> String {
        let bundleDict = Bundle.main.infoDictionary!
        let appName = bundleDict["CFBundleName"] as! String
        return appName
    }
}
    

