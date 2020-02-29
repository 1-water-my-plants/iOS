//
//  WelcomeViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 2/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var plant1: UIView!
    @IBOutlet weak var plant2: UIView!
    @IBOutlet weak var plant3: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundedOutViews()

        // Do any additional setup after loading the view.
    }
    
    func roundedOutViews() {
        plant1.layer.cornerRadius = 15
        plant2.layer.cornerRadius = 15
        plant3.layer.cornerRadius = 15
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
