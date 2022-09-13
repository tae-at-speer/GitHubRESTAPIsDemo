//
//  MainViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

enum UserListType:String {
    case none
    case followers
    case following
}

enum UserListViewModelRoute {
    case initial
    case showUserProfileVC(user: GitHubUser)
}

struct UserListViewTopBarInformation
{
    var titleStr: String
    var isBackButtonHidden: Bool
    var isSearchBarHidden: Bool
    var consSearchBarHeight: CGFloat
    var isLblSearchInstructionHidden: Bool
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
    
    private var user: GitHubUser?
    private var type: UserListType = .none
    private var users: [GitHubUser] = []
    private var pageNo: Int = 1
    private var shouldLoadingNextPage: Bool = true
    private var lastKeyword: String?
    
    let topBarInformation: Observable<UserListViewTopBarInformation?> = Observable(nil)
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
    
    func displayNextPage(keyword: String)
    {
        switch type {
        case .none:
            if !shouldLoadingNextPage { return }
            if users.count == 0 { return }
            pageNo += 1
            searchUser(keyword: keyword)
            break
        case .following, .followers:
            if !shouldLoadingNextPage { return }
            if users.count == 0 { return }
            pageNo += 1
            getUserFollow()
            break
        }
        
    }
    
    func searchUser(keyword: String)
    {
        if lastKeyword != keyword
        {
            //Keyword changed, reset user list and pageNo
            users = []
            pageNo = 1
        }
        
        lastKeyword = keyword
        
        viewNotFoundStatus.value = UserListViewNotFoundStatus.init(text:"" , isHidden: true)
        indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        shouldLoadingNextPage = false
        
        DispatchQueue.global(qos: .background).async {
            
            let params = ["q":keyword,
                          "per_page":UserDefaultHelper.standard.getData(type: String.self, forKey: .searchPerPage)!,
                          "page":String(self.pageNo)]
            
            ApiService().searchUser(params: params) { [weak self] success, data, error in
                
                self?.indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: false, isHidden: true)
                self?.shouldLoadingNextPage = true
                
                do {
                    guard let data = data else
                    {
                        if self?.pageNo == 1
                        {
                            self?.gitHubUserCellViewModels.value = []
                            self?.errorMessage.value = String().LString("Error_DidNotReceiveData")
                        }
                        else
                        {
                            self?.shouldLoadingNextPage = false
                        }
                        return
                    }
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]

                    guard let items = jsonResult["items"] as? [[String: Any]] else {
                        self?.errorMessage.value = String().LString("Error_UnexpectedJsonFormat")
                        return
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: items, options: .prettyPrinted)
                    
                    if self?.users.count == 0
                    {
                        self?.users = try JSONDecoder().decode([GitHubUser].self, from: jsonData)
                    }
                    else
                    {
                        self?.users += try JSONDecoder().decode([GitHubUser].self, from: jsonData)
                    }
                    
                    
                    self?.fetchData()
                }
                catch
                {
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func getUserFollow()
    {
        guard let user = user else
        {
            return
        }
        
        viewNotFoundStatus.value = UserListViewNotFoundStatus.init(text:"" , isHidden: true)
        indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        shouldLoadingNextPage = false
        
        DispatchQueue.global(qos: .background).async {
            
            let params = ["per_page":UserDefaultHelper.standard.getData(type: String.self, forKey: .searchPerPage)!,
                          "page":String(self.pageNo)]
            ApiService().getUserFollow(type: self.type.rawValue, login: user.login, params:params) { [weak self] success, data, error in
                
                self?.shouldLoadingNextPage = true
                self?.indicatorStatus.value = UserListIndicatorStatus.init(isAnimated: false, isHidden: true)

                do {
                    guard let data = data else
                    {
                        if self?.pageNo == 1
                        {
                            self?.gitHubUserCellViewModels.value = []
                            self?.errorMessage.value = String().LString("Error_DidNotReceiveData")
                        }
                        else
                        {
                            self?.shouldLoadingNextPage = false
                        }
                        return
                    }

                    if self?.users.count == 0
                    {
                        self?.users = try JSONDecoder().decode([GitHubUser].self, from: data)
                    }
                    else
                    {
                        self?.users += try JSONDecoder().decode([GitHubUser].self, from: data)
                    }
                    
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
    
    func setUp(user: GitHubUser?, type: UserListType)
    {
        self.user = user
        self.type = type
        
        var titleStr = ""
        var isBackButtonHidden = true
        var isSearchBarHidden = false
        var consSearchBarHeight = 44.0
        var isLblSearchInstructionHidden = false
        
        switch type {
        case .none:
            titleStr = String().LString("Common_GitHubUserBrowser")
            break
        case .followers:
            titleStr = "\(self.user?.login ?? "")'s \(String().LString("Common_Followers"))"
            isBackButtonHidden = false
            isSearchBarHidden = true
            consSearchBarHeight = 0
            isLblSearchInstructionHidden = true
            getUserFollow()
            break
        case .following:
            titleStr = "\(self.user?.login ?? "")'s \(String().LString("Common_Following"))"
            isBackButtonHidden = false
            isSearchBarHidden = true
            consSearchBarHeight = 0
            isLblSearchInstructionHidden = true
            getUserFollow()
            break
        }
        
        topBarInformation.value = .init(titleStr: titleStr,
                                        isBackButtonHidden: isBackButtonHidden,
                                        isSearchBarHidden: isSearchBarHidden,
                                        consSearchBarHeight: consSearchBarHeight,
                                        isLblSearchInstructionHidden: isLblSearchInstructionHidden)
    }
   
}


