//
//  ThemeManager.swift
//  WeatherDemo
//
//  Created by Jason Huang on 2022/3/11.
//

import UIKit

enum AppTheme {
    case light, dark
}

enum AppThemeSetting: Int {
    case system = 0
    case light = 1
    case dark = 2
    
    var name: String {
        switch self {
        case .system:         return "System"
        case .dark:         return "Dark"
        case .light:         return "Light"
        }
    }
    
    @available(iOS 12.0, *)
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:         return .unspecified
        case .dark:         return .dark
        case .light:         return .light
        }
    }
}

@available(iOS 12.0, *)
extension UIUserInterfaceStyle {
    
    func themeSetting() -> AppThemeSetting {
        switch self {
        case .unspecified:         return .system
        case .dark:             return .dark
        case .light:             return .light
        @unknown default:         return .system
        }
    }
    
}

typealias ThemeSettingChangeHandler = (_ themeSetting: AppThemeSetting) -> ()

class ThemeManager: NSObject {

    static let instance = ThemeManager()
    
    var themeSetting: AppThemeSetting {
        set {
            if themeSetting != newValue {
                Settings.themeSetting = newValue
                updateTheme()
            }
        }
        get {
            return Settings.themeSetting
        }
    }
    
    var currentTraitCollection: UITraitCollection? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.traitCollection
    }
    
    private var themeSettingChangeHandlers = [ThemeSettingChangeHandler]()
    
    // MARK: - Public
    
    func registerForThemeSettingChangeUpdates(handler: @escaping ThemeSettingChangeHandler) {
        themeSettingChangeHandlers.append(handler)
    }
    
    func initialize() {
        if self.themeSetting != .system {
            updateTheme()
        }
    }
    
    func updateCurrentTraitCollection() {
        if #available(iOS 13.0, *) {
            if let traitCollection = currentTraitCollection {
                UITraitCollection.current = traitCollection
            }
        }
    }
    
    // MARK: - Private
    
    private func updateTheme() {
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = self.themeSetting.interfaceStyle
                
                // Notify handlers
                for handler in themeSettingChangeHandlers {
                    handler(self.themeSetting)
                }
            }
        }
    }
    
}
