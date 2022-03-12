//
//  BaseRequest.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import UIKit

typealias RequestCompletionBlock = (_ request: BaseRequest?, _ response: Any?, _ error: String?) -> Void

class BaseRequest: NSObject {
    
    fileprivate var requestDate: Date!
    fileprivate var completion: RequestCompletionBlock?
    
    // MARK: - Public
    
    func start(completion: @escaping RequestCompletionBlock) {
        self.completion = completion
        let url = urlString()
        guard let urlRequest = self.newURLRequest(url: url, httpMethod: self.httpMethod()) else {
            self.printAndComplete(error: "Request Error: - can't create a request for URL: " + self.url())
            return
        }
        // Log the Method calls
        print(self.httpMethod() + " " + url)
        // Start Network Activity Indicator
        NetworkActivityIndicatorManager.networkOperationStarted()
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                // Stop Network Activity Indicator
                NetworkActivityIndicatorManager.networkOperationFinished()

                guard error == nil else {
                    self.printAndComplete(error: (error?.localizedDescription ?? "" ))
                    return
                }
                
                // make sure we got data
                guard let responseData = data else {
                    self.printAndComplete(error: "Request Error: did not receive data")
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    completion(self, self.responseModel(data: jsonData), nil)
                } catch {
                    if self.httpMethod() == "GET" {
                        self.printAndComplete(error: "Request Error: error trying to convert data to JSON")
                    } else {
                        completion(self, response, nil)
                    }
                }
            }
        }.resume()
    }

    // MARK: - Functions to override
    
    func httpMethod() -> String {
        return "GET"
    }
    
    func url() -> String {
        return ""
    }
    
    func fullUrl() -> String {
        return ""
    }
    
    func httpBody() -> Any? {
        return nil
    }
    
    func headers() -> [[String:String]] {
        return [[String:String]]()
    }
    
    func responseModel(data: Any) -> Any? {
        return data
    }
    
    func shouldIncludeContentType() -> Bool {
        return true
    }
    
    // MARK: - Private
    
    private func newURLRequest(url: String!, httpMethod: String) -> URLRequest? {
        guard let urlObj = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: urlObj)
        request.httpMethod = httpMethod
        if self.shouldIncludeContentType() {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        }
        let appName = Utils.getAppName()
        let appVersion = Utils.appVersion()
        let osDescriptor = "iOS/" + Utils.getSystemVersion()
        request.setValue(appName, forHTTPHeaderField: "AppName")
        request.setValue(appVersion, forHTTPHeaderField: "AppVersion")
        request.setValue(osDescriptor, forHTTPHeaderField: "OSVersion")
        for header in headers() {
            request.setValue(header["value"], forHTTPHeaderField: header["key"]!)
        }
        
        if let httpBody = httpBody() as? String {
            request.httpBody = httpBody.data(using: .utf8)
        } else if let httpBody = httpBody() {
            request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .init(rawValue: 0))
        }
        return request
    }
    
    private func printAndComplete(error: String) {
        print(error)
        self.completion?(nil, nil, error)
    }
    
    private func urlString() -> String {
        return Settings.hostPathDataApi + self.url()
    }
    
}
