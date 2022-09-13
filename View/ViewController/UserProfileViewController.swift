//
//  UserProfileViewController.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLoginName: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    
    lazy var viewModel = {
       UserProfileViewModel()
    }()
    
    init(login: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.setLogin(login: login)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUIs()
        setUpBinding()
        setUpViewModel()
    }

    func setUpUIs()
    {
        //UILabel
        lblTitle.text = String().LString("Common_UserProfile")
        
        //UIImageView
        imageViewMain.layer.masksToBounds = false
        imageViewMain.layer.cornerRadius = imageViewMain.frame.height/2
        imageViewMain.clipsToBounds = true
    }
    
    func setUpBinding()
    {
        viewModel.userProfileInformation.bind { [weak self] in
            guard let info = $0 else { return }
            DispatchQueue.main.async {
                self?.imageViewMain.sd_setImage(with: URL.init(string: info.avatarUrlStr), placeholderImage: nil, options: .avoidAutoSetImage) { [weak self] image, error, type, url in
                        self?.imageViewMain.image = image
                }
                self?.lblUserName.text = info.userNameStr
                self?.lblLoginName.text = info.loginNameStr
                self?.lblFollowerCount.text = info.followerCountStr
                self?.lblFollowingCount.text = info.followingCountStr
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
        
        viewModel.errorMessage.bind { [weak self] in
            guard let message = $0 else { return }
            DispatchQueue.main.async {
                self?.showErrorMessageAlert(message: message)
            }
        }
        
        viewModel.route.bind { [weak self] _type in
            switch _type{
            case .initial: break
            case .showUserListVC(let user, let type):
                self?.navigationController?.pushViewController(UserListViewController.init(user: user, type: type), animated: true)
            }
        }
    }
    
    func setUpViewModel()
    {
        viewModel.getUserProfile()
    }
    
    @IBAction func backDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewFollowerDidTap(_ sender: Any) {
        viewModel.showFollowerUserList()
    }
    
    
    @IBAction func viewFollowingDidTap(_ sender: Any) {
        viewModel.showFollowingUserList()
    }
    
}
