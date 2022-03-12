//
//  KeyedArchiverAndUnarchiver.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import Foundation

class KeyedUnarchiver : NSKeyedUnarchiver {
    open override class func unarchiveObject(with data: Data) -> Any? {
        do {
            let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data)
            return object
        }
        catch let error {
            print("unarchiveObject(with:) \(error.localizedDescription)")
            return nil
        }
    }

    open override class func unarchiveObject(withFile path: String) -> Any? {
        do {
            let data = try Data(contentsOf: URL.init(fileURLWithPath: path))
            let object = try unarchivedObject(ofClasses: [NSObject.self], from: data)
            return object
        }
        catch let error {
            print("unarchiveObject(withFile:) \(error.localizedDescription)")
            return nil
        }
    }
}

class KeyedArchiver : NSKeyedArchiver {
    
    open override class func archivedData(withRootObject rootObject: Any) -> Data {
        do {
            let object = try NSKeyedArchiver.archivedData(withRootObject: rootObject, requiringSecureCoding: true)
            return object
        }
        catch let error {
            print("archivedData(withRootObject:) \(error.localizedDescription)")
            return Data()
        }
    }
    
}

