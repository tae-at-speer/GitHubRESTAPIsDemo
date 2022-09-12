//
//  MainViewModel.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

struct MainVMViewNotFoundStatus
{
    var text: String
    var isHidden: Bool
}

struct MainVMIndicatorStatus
{
    var isAnimated: Bool
    var isHidden: Bool
}

class MainViewModel {
    
    private var users: [GitHubUser] = []
    private var pageNo: Int = 0
    
    let viewNotFoundStatus: Observable<MainVMViewNotFoundStatus?> = Observable(nil)
    let indicatorStatus: Observable<MainVMIndicatorStatus?> = Observable(nil)
    let gitHubUserCellViewModels: Observable<[GitHubUserCellViewModel]> = Observable([])
    let errorMessage: Observable<String?> = Observable(nil)

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
        viewNotFoundStatus.value = MainVMViewNotFoundStatus.init(text:String().LString("Erro_NotFound") , isHidden: (tempList.count != 0))
    }
    
    func searchUser(keyword: String)
    {
        viewNotFoundStatus.value = MainVMViewNotFoundStatus.init(text:"" , isHidden: true)
        indicatorStatus.value = MainVMIndicatorStatus.init(isAnimated: true, isHidden: false)
        
        DispatchQueue.global(qos: .background).async {
            
            let params = ["q":keyword,
                          "per_page":UserDefaultHelper.standard.getData(type: String.self, forKey: .searchPerPage)!,
                          "page":String(self.pageNo)]
            
            ApiService().searchUser(params: params) { [weak self] success, data, error in
                
                self?.indicatorStatus.value = MainVMIndicatorStatus.init(isAnimated: false, isHidden: true)

                do {
                    guard let data = data else
                    {
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


