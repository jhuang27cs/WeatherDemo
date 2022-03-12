//
//  Extensions.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

extension NSNumber {
    func secondsFrom1970ToDate() -> Date {
        let epochTime = TimeInterval(self.doubleValue)
        return Date(timeIntervalSince1970: epochTime)
    }
    
    func toDateString(withWeekDay: Bool = false) -> String {
        let date = self.secondsFrom1970ToDate()
        let dateFormatter = DateFormatter()
        let format = withWeekDay ? "EEEE, MMMM dd, yyyy" : "dd-MM-yyyy"
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func twoDecimalString() -> String {
        let doubleV: Double = self.doubleValue
        return String(format: "%.2f", doubleV)
    }
}
