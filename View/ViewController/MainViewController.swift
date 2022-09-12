//
//  MainViewController.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSearchInstruction: UILabel!
    @IBOutlet weak var viewNotFound: UIView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    lazy var viewModel = {
       MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUIs()
        setUpBinding()
        setUpViewModel()
    }
    
    func setUpUIs()
    {
        //UILabel
        lblTitle.text = String().LString("Common_GitHubUserBrowser")
        lblSearchInstruction.text = String().LString("Common_SearchInstruction")
        
        //UIView
        viewNotFound.isHidden = true //Default hidden
        
        //UITableView
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        tableViewMain.backgroundColor = .clear
        tableViewMain.separatorStyle = .none
        
        tableViewMain.register(GitHubUserTableViewCell.nib, forCellReuseIdentifier: GitHubUserTableViewCell.identifier)
        
        //UIActivityIndicatorView
        indicator.isHidden = true //Default hidden
        
        //UISearchBar
        searchBar.delegate = self
    }
    
    func setUpBinding()
    {
        viewModel.viewNotFoundStatus.bind { [weak self] in
            guard let info = $0 else { return }
            DispatchQueue.main.async {
                self?.viewNotFound.isHidden = info.isHidden
            }
        }
        
        viewModel.indicatorStatus.bind { [weak self] in
            guard let info = $0 else { return }
            DispatchQueue.main.async {
                self?.indicator.isHidden = info.isHidden
                if info.isAnimated {
                    self?.indicator.startAnimating()
                }
                else
                {
                    self?.indicator.stopAnimating()
                }
            }
        }
        
        viewModel.gitHubUserCellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableViewMain.reloadData()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] in
            guard let message = $0 else { return }
            DispatchQueue.main.async {
                self?.showErrorMessageAlert(message: message)
            }
        }
        
        viewModel.route.bind { [weak self] _type in
            switch _type{
            case .initial: break
            case .showUserProfileVC(let user):
                self?.navigationController?.pushViewController(UserProfileViewController.init(), animated: true)
            }
        }
    }
    
    func setUpViewModel()
    {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellViewModelCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubUserTableViewCell.identifier, for: indexPath) as? GitHubUserTableViewCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.selectionStyle = .none;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.push(indexPath: indexPath)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        lblSearchInstruction.isHidden = true
        searchBar.resignFirstResponder()
        viewModel.searchUser(keyword: searchBar.text ?? "")
    }
}

