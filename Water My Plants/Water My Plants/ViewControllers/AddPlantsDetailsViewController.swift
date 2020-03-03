//
//  AddPlantsDetailsViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class AddPlantsDetailsViewController: UIViewController {

    
    // IB Outlets
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var howManyPlantsTextField: UITextField!
    @IBOutlet weak var h2oFrequencyPerWeekTextLabel: UITextField!
    @IBOutlet weak var textWaterNotificationsToggleLbl: UILabel!
    @IBOutlet weak var wateringDaysPerWeek: UITextField!
    
    // need to add model attribute for totalPlants - Int or String
    
    
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
    
    //IB Actions
    @IBAction func textWaterNotficationsToggle(_ sender: Any) {
    }
    @IBAction func takePhotoBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func savePlantBtnWasPressed(_ sender: Any) {
    }
    
}
