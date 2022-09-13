//
//  String+Customization.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

extension String {
    
    func LString(_ LString :String) -> String
    {
        return Bundle.main.localizedString(forKey: LString, value: "", table: UserDefaultHelper.standard.getData(type: String.self, forKey: .localization))
    }
}

