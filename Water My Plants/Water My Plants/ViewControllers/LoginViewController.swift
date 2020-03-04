//
//  LoginViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginAfterSignUp(with loginRequest: LoginRequest)
}

class LoginViewController: UIViewController {
    
    @IBOutlet private var signInView: UIView!
    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var createAccountButton: UIButton!
    
    let loginController = LoginController.shared
    
    func roundRegisterButton() {
        createAccountButton.layer.cornerRadius = 5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        curvedView()
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
        roundRegisterButton()
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let username = self.usernameTF.text, !username.isEmpty,
            let password = self.passwordTF.text, !password.isEmpty else {
                let alert = UIAlertController(title: "Missing some fields.", message: "Check your information and try again 😀", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "👍", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        // create a login request
        let loginRequest = LoginRequest(username: username, password: password)
        self.login(with: loginRequest)
    }
    
    func login(with loginRequest: LoginRequest) {
        loginController.login(with: loginRequest) { error in
            DispatchQueue.main.async {
                
            if let error = error {
                let alert = UIAlertController(title: "Error Occured", message: "Check your username and password and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "👍", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("error occured during login: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "DashboardSegue", sender: nil)
                }
            }
        }
    }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            guard let vc = segue.destination as? RegisterViewController else { return }
            vc.delegate = self
        }
    }

    lazy var usernameTF: UITextField = {
        let usernameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 385, width: signInView.bounds.size.width - 35, height: 50.00))
        self.view.addSubview(usernameTextField)
        usernameTextField.backgroundColor = .white
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.layer.borderWidth = 0.5
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.layer.borderColor = UIColor.black.cgColor
        return usernameTextField
    }()
    
    lazy var passwordTF: UITextField = {
        let passwordTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 500, width: signInView.bounds.size.width - 35, height: 50.00))
        self.view.addSubview(passwordTextField)
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        return passwordTextField
    }()
    
    func curvedView() {
        signInView.layer.cornerRadius = 20
        signInView.layer.cornerCurve = .continuous
    }
}
extension LoginViewController: LoginViewControllerDelegate {
    func loginAfterSignUp(with loginRequest: LoginRequest) {
        DispatchQueue.main.async {
            self.login(with: loginRequest)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
