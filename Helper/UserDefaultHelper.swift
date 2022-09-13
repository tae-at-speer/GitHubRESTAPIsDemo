//
//  UserDefaultHelper.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case serverUrl
    case localization
    case searchPerPage
}

final class UserDefaultHelper {
    
    static let standard = UserDefaultHelper()
    
    func setData<T>(value: T, key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    func removeData(key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
}
