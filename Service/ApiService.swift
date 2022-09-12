//
//  ApiService.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

class ApiService {
    
    func requestUrl(string: String) -> String
    {
        return UserDefaultHelper.standard.getData(type: String.self, forKey: .serverUrl)! + string
    }
    
    // MARK: - Search User
    func searchUser(params: [String:String], completion: @escaping (Bool, Data?, String?) -> ())
    {
        let url = requestUrl(string: "search/users")
        
        HttpRequestHelper().GET(url: url,
                                params: params,
                                httpHeader: .application_json) { success, data, errorStr in
            
            if success {
                completion(true, data, nil)
            } else {
                completion(false, nil, "Error: getOffer Request failed")
            }
        }
    }
    
    func getUserProfile(login: String, completion: @escaping (Bool, Data?, String?) -> ())
    {
        let url = requestUrl(string: "users/\(login)")
        
        HttpRequestHelper().GET(url: url,
                                params: [:],
                                httpHeader: .application_json) { success, data, errorStr in
            
            if success {
                completion(true, data, nil)
            } else {
                completion(false, nil, "Error: getOffer Request failed")
            }
        }
    }
    
}
