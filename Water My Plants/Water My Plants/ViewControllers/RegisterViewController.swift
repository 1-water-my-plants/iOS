//
//  RegisterViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 2/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var signUPButton: UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        curveRegisterView()
        view.addSubview(usernameTF)
        view.addSubview(passwordTF)
        view.addSubview(phoneTF)
        

        // Do any additional setup after loading the view.
    }
    
    func curveRegisterView() {
        registerView.layer.cornerRadius = 20
        registerView.layer.cornerCurve = .continuous
    }
    
    lazy var usernameTF: UITextField = {
        let userNameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 390, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(userNameTextField)
        userNameTextField.backgroundColor = .white
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.borderColor = UIColor.black.cgColor
        return userNameTextField
    }()
    
    lazy var passwordTF: UITextField = {
        let passwordTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 498, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(passwordTextField)
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        return passwordTextField
    }()
    
    lazy var phoneTF: UITextField = {
        let phoneNumberTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 615, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.backgroundColor = .white
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.layer.borderWidth = 0.5
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        return phoneNumberTextField
        
    }()
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let username = self.usernameTF.text, !username.isEmpty,
            let password = self.passwordTF.text, !password.isEmpty,
            let phoneNumber = self.phoneTF.text, !phoneNumber.isEmpty else {
                let alert = UIAlertController(title: "Missing some fields", message: "Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        //Create a signup form
        let signUpRequest = SignUpRequest(username: username, password: password, phoneNumber: phoneNumber)
        
        
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
