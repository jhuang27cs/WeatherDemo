//
//  NetworkActivityIndicatorManager.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import UIKit

class NetworkActivityIndicatorManager: NSObject {
    private static var loadingCount = 0
    
    class func networkOperationStarted() {
        #if os(iOS)
            if loadingCount == 0 {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            }
            loadingCount += 1
        #endif
    }
    
    class func networkOperationFinished() {
        #if os(iOS)
            if loadingCount > 0 {
                loadingCount -= 1
            }
            if loadingCount == 0 {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        #endif
    }
}
