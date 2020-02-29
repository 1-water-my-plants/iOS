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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        curveRegisterView()
        addTextFields()

        // Do any additional setup after loading the view.
    }
    
    func curveRegisterView() {
        registerView.layer.cornerRadius = 20
        registerView.layer.cornerCurve = .continuous
    }
    
    func addTextFields() {
        let firstNameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 390, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(firstNameTextField)
        firstNameTextField.backgroundColor = .white
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.layer.borderWidth = 0.5
        firstNameTextField.layer.cornerRadius = 5
        firstNameTextField.layer.borderColor = UIColor.black.cgColor
        
        let lastNameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 498, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(lastNameTextField)
        lastNameTextField.backgroundColor = .white
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.layer.borderWidth = 0.5
        lastNameTextField.layer.cornerRadius = 5
        lastNameTextField.layer.borderColor = UIColor.black.cgColor
        
        let phoneNumberTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 615, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(phoneNumberTextField)
        phoneNumberTextField.backgroundColor = .white
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.layer.borderWidth = 0.5
        phoneNumberTextField.layer.cornerRadius = 5
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        
        let userNameTextField: UITextField = UITextField(frame: CGRect(x: 17, y: 735, width: registerView.bounds.size.width - 35, height: 50))
        self.view.addSubview(userNameTextField)
        userNameTextField.backgroundColor = .white
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.layer.borderWidth = 0.5
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.borderColor = UIColor.black.cgColor
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
