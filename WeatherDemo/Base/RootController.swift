//
//  RootController.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/12.
//

import UIKit

class RootController{
    static let shared = RootController()
    weak var window:UIWindow?
    
    func initRootController(window:UIWindow?){
        self.window = window
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
