//
//  SettingsBundleHelper.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 07/02/2024.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let source = "source_preference"
    }

    enum Source: Int {
        case server = 0
        case demo
    }
    
    class var source: Source {
        let key = UserDefaults.standard.integer(forKey: SettingsBundleKeys.source)
        return Source(rawValue: key)!
    }    
}
