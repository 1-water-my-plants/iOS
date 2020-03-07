//
//  EditPlantViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController {
    
    var plant: Plant?
    var apiController: APIController?
    
    @IBOutlet private var speciesTF: UITextField!
    @IBOutlet private var nicknameTF: UITextField!
    @IBOutlet private var wateringFrequencyTF: UITextField!
    @IBOutlet private var wateringDay: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let plant = plant else { return }
        
        self.speciesTF.text = self.plant?.species
        self.nicknameTF.text = self.plant?.nickname

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
