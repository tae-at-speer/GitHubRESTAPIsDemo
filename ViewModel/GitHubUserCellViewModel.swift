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
    
    func getUser() -> GitHubUser
    {
        return user
    }
    
    func getLoginName() -> String
    {
        return user.login
    }
    
    func getAvatarUrl() -> URL
    {
        return URL.init(string: user.avatar_url)!
    }
    
}
