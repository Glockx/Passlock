//
//  UserDefaultService.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/19.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserSettings: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("isAutoLockEnabled", defaultValue: true)
    var isAutoLockEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("autoLockTime", defaultValue: 10)
    var autoLockTime: Double {
        willSet {
            objectWillChange.send()
        }
    }
}
