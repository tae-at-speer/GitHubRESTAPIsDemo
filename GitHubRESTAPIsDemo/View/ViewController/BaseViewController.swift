//
//  BaseViewController.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showErrorMessageAlert(message: String)
    {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
