//
//  MainViewController.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var tableViewMain: UITableView!
    
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
        
    }
    
    func setUpBinding()
    {
        
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
