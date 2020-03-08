//
//  PasswordViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet private var passwordTF: UITextField!
    
    var loginController = LoginController.shared
    var user: User?
    var apiController = APIController()
    var signupController = SignUpController.shared
    @IBAction func passwordSaved(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        guard let newPassword = passwordTF.text else { return }
        self.apiController.updateUser(with: newPassword) { (result) in
            
        }
        let alert = UIAlertController(title: "Success!", message: "Password has been updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "👍", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
