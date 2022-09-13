//
//  UserProfileViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

enum UserProfileViewModelRoute {
    case initial
    case showUserListVC(user: GitHubUser, type: UserListType)
}

struct UserProfileInformation
{
    var avatarUrlStr: String
    var userNameStr: String
    var loginNameStr: String
    var followerCountStr: String
    var followingCountStr: String
}

struct UserProfileIndicatorStatus
{
    var isAnimated: Bool
    var isHidden: Bool
}

class UserProfileViewModel {
    
    private var login: String?
    private var user: GitHubUser?
    
    let indicatorStatus: Observable<UserProfileIndicatorStatus?> = Observable(nil)
    let userProfileInformation: Observable<UserProfileInformation?> = Observable(nil)
    let errorMessage: Observable<String?> = Observable(nil)
    let route: Observable<UserProfileViewModelRoute> = Observable(.initial)
    
    init()
    {
        setUserProfileInformation()
    }
    
    deinit{ print("UserProfileViewModel deinit") }
    
    func showFollowerUserList()
    {
        guard let user = user else
        {
            errorMessage.value = String().LString("Error_UnexpectedGitHubUserObject")
            return
        }
        
        route.value = .showUserListVC(user: user, type: .followers)
    }
    
    func showFollowingUserList()
    {
        guard let user = user else
        {
            errorMessage.value = String().LString("Error_UnexpectedGitHubUserObject")
            return
        }
        
        route.value = .showUserListVC(user: user, type: .following)
    }
    
    func getUserProfile()
    {
        guard let login = login else
        {
            errorMessage.value = String().LString("Error_UnexpectedLoginName")
            return
        }
        
        indicatorStatus.value = UserProfileIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        DispatchQueue.global(qos: .background).async {

            ApiService().getUserProfile(login: login) { [weak self] success, data, error in
                
                self?.indicatorStatus.value = UserProfileIndicatorStatus.init(isAnimated: false, isHidden: true)

                do {
                    guard let data = data else
                    {
                        self?.errorMessage.value = String().LString("Error_DidNotReceiveData")
                        return
                    }
                    
                    self?.user = try JSONDecoder().decode(GitHubUser.self, from: data)
                    self?.setUserProfileInformation()
                }
                catch
                {
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func setUp(login: String)
    {
        self.login = login
    }
    
    func setUserProfileInformation()
    {
        let avatarUrlStr = user?.avatar_url ?? ""
        let userNameStr = user?.name == "" ? user?.login ?? "" : user?.name ?? ""
        let loginNameStr = user?.login ?? ""
        let followerCountStr = "\(String(user?.followers ?? 0)) \(String().LString("Common_Followers"))"
        let followingCountStr = "\(String(user?.following ?? 0)) \(String().LString("Common_Following"))"
        
        userProfileInformation.value = UserProfileInformation.init(avatarUrlStr: avatarUrlStr,
                                                                   userNameStr: userNameStr,
                                                                   loginNameStr: loginNameStr,
                                                                   followerCountStr: followerCountStr,
                                                                   followingCountStr: followingCountStr)
    }
    
}
