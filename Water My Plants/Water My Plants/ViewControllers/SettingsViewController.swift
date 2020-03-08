//
//  SettingsViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!
    @IBOutlet private var passwordLabel: UILabel!
    
    let registerController = RegisterViewController()
    var user: User?
    var apiController: APIController?

    @IBAction func signoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Success", message: "You have successfully logged out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "👍", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else { return }
        
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangePassword" {
            guard let passwordVC = segue.destination as? PasswordViewController else { return }
            
            passwordVC.user = user
        }
    }
    

}
