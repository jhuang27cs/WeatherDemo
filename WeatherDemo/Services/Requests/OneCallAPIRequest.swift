//
//  OneCallAPIRequest.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import Foundation

enum ExculdeType {
    case current, minutely, hourly, daily, alerts
    
    // MARK: - Public
    
    func urlParameter() -> String {
        var result = ""
        switch self {
        case .current:              result = "current"
        case .minutely:             result = "minutely"
        case .hourly:               result = "hourly"
        case .daily:                result = "daily"
        case .alerts:               result = "alerts"
        }
        return result
    }
}

enum Units: String {
    case standard = "standard"
    case metric = "metric"
    case imperial = "imperial"
}

class OneCallAPIRequest: BaseRequest {

    var requestURL: String!
    
    // MARK: - Initialize
    
    init(latitude: Double, longitude: Double,
         exclude: [ExculdeType]? = [.alerts, .hourly, .minutely],
         units: Units? = .metric,
         lang: String? = nil) {
        super.init()
        let excludedStr = self.convert(excludes: exclude)
        var url = "\(kOneCallAPI)lat=\(latitude)&lon=\(longitude)&exclude=\(excludedStr)"
        if let u = units {
            url += "&units=\(u.rawValue)"
        }
        if let l = lang {
            url += "&lang=\(l)"
        }
        url += "&appid=\(kJasonAPIKeys)"
        self.requestURL = url
    }
    
    // MARK: - Overridden
    
    override func url() -> String {
        return self.requestURL
    }
    
    override func responseModel(data: Any) -> Any? {
        let result = OneCallAPIResponseModel()
        guard let responseDic = data as? NSDictionary else {
            return result
        }
        result.mj_setKeyValues(responseDic)
        return result
    }
    
    // MARK: - Private Methods
    
    private func convert(excludes: [ExculdeType]?) -> String {
        guard let exc = excludes else {
            return ""
        }
        var res = ""
        for e in exc {
            res += e.urlParameter() + ","
        }
        res.removeLast()
        return res
    }
}
