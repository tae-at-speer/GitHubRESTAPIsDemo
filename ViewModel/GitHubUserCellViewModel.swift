//
//  GitHubUserCellViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

class GitHubUserCellViewModel {
    
    deinit{ print("GitHubUserCellViewModel deinit") }
    
    private var user: GitHubUser
    
    init(user: GitHubUser)
    {
        self.user = user
    }
    
}
