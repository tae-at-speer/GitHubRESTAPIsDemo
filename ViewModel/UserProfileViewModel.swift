//
//  UserProfileViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

struct UserProfileInformation
{
    var avatarUrlStr: String
    var userNameStr: String
    var loginNameStr: String
}

class UserProfileViewModel {
    
    private var login: String?
    private var user: GitHubUser?
    
    let indicatorStatus: Observable<MainVMIndicatorStatus?> = Observable(nil)
    let userProfileInformation: Observable<UserProfileInformation?> = Observable(nil)
    let errorMessage: Observable<String?> = Observable(nil)
    
    init()
    {
        setUserProfileInformation()
    }
    
    deinit{ print("UserProfileViewModel deinit") }
    
    func getUserProfile()
    {
        guard let login = login else
        {
            errorMessage.value = String().LString("Error_UnexpectedLoginName")
            return
        }
        
        indicatorStatus.value = MainVMIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        DispatchQueue.global(qos: .background).async {

            ApiService().getUserProfile(login: login) { [weak self] success, data, error in
                
                self?.indicatorStatus.value = MainVMIndicatorStatus.init(isAnimated: false, isHidden: true)

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
    
    func setLogin(login: String)
    {
        self.login = login
    }
    
    func setUserProfileInformation()
    {
        let avatarUrlStr = user?.avatar_url ?? ""
        let userNameStr = user?.name == "" ? user?.login ?? "" : user?.name ?? ""
        let loginNameStr = user?.login ?? ""
         
        userProfileInformation.value = UserProfileInformation.init(avatarUrlStr: avatarUrlStr,
                                                                   userNameStr: userNameStr,
                                                                   loginNameStr: loginNameStr)
    }
    
}
