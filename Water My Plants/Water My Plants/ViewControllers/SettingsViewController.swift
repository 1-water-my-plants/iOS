//
//  SettingsViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func signoutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Success", message: "You have successfully logged out.", preferredStyle: .alert)
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
