//
//  MainViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

enum UserListViewModelRoute {
    case initial
    case showUserProfileVC(user: GitHubUser)
}

struct UserListViewNotFoundStatus
{
    var text: String
    var isHidden: Bool
}

struct UserListIndicatorStatus
{
    var isAnimated: Bool
    var isHidden: Bool
}

class UserListViewModel {
    
    private var users: [GitHubUser] = []
    private var pageNo: Int = 0
    
    let viewNotFoundStatus: Observable<UserListViewNotFoundStatus?> = Observable(nil)
    let indicatorStatus: Observable<UserListIndicatorStatus?> = Observable(nil)
    let gitHubUserCellViewModels: Observable<[GitHubUserCellViewModel]> = Observable([])
    let errorMessage: Observable<String?> = Observable(nil)
    let route: Observable<UserListViewModelRoute> = Observable(.initial)

    init() {}
    
    deinit{ print("MainViewModel deinit") }
    
    func fetchData()
    {
        var tempList = [] as [GitHubUserCellViewModel]
        for user in users
        {
            let cellVM = GitHubUserCellViewModel.init(user: user)
            tempList.append(cellVM)
        }
        
        gitHubUserCellViewModels.value = tempList
        viewNotFoundStatus.value = UserListViewNotFoundStatus.init(text:String().LString("Error_NotFound") , isHidden: (tempList.count != 0))
    }
    
    func push(indexPath: IndexPath)
    {
        let cellVM = getCellViewModel(at: indexPath)
        route.value = .showUserProfileVC(user: cellVM.getUser())
    }
    
    func searchUser(keyword: String)
    {
        viewNotFoundStatus.value = UserListViewNotFoundStatus.init(text:"" , isHidden: true)
        indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        DispatchQueue.global(qos: .background).async {
            
            let params = ["q":keyword,
                          "per_page":UserDefaultHelper.standard.getData(type: String.self, forKey: .searchPerPage)!,
                          "page":String(self.pageNo)]
            
            ApiService().searchUser(params: params) { [weak self] success, data, error in
                
                self?.indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: false, isHidden: true)

                do {
                    guard let data = data else
                    {
                        self?.gitHubUserCellViewModels.value = []
                        self?.errorMessage.value = String().LString("Error_DidNotReceiveData")
                        return
                    }
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
                    
                    guard let items = jsonResult["items"] as? [[String: Any]] else {
                        self?.errorMessage.value = String().LString("Error_UnexpectedJsonFormat")
                        return
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: items, options: .prettyPrinted)
                    self?.users = try JSONDecoder().decode([GitHubUser].self, from: jsonData)
                    
                    self?.fetchData()
                }
                catch
                {
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> GitHubUserCellViewModel
    {
        return gitHubUserCellViewModels.value[indexPath.row]
    }
    
    func getCellViewModelCount() -> Int
    {
        return gitHubUserCellViewModels.value.count
    }
    
   
}

