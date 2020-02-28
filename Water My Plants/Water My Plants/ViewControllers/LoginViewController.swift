//
//  LoginViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    func roundRegisterButton() {
        createAccountButton.layer.cornerRadius = 5
    }

    func addUserNameTextField() {
        let userNameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 385, width: signInView.bounds.size.width - 35, height: 50.00))
        self.view.addSubview(userNameTextField)
        userNameTextField.backgroundColor = .white
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func addPasswordTextField() {
        let passwordTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 500, width: signInView.bounds.size.width - 35, height: 50.00))
        self.view.addSubview(passwordTextField)
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curvedView()
        addUserNameTextField()
        addPasswordTextField()
        roundRegisterButton()
    }
    
    func curvedView() {
        signInView.layer.cornerRadius = 20
        signInView.layer.cornerCurve = .continuous
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
