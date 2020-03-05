//
//  AddPlantsDetailsViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CTPicker

class AddPlantsDetailsViewController: UIViewController, UITextFieldDelegate, CTPickerDelegate {
    var plantController: PlantController!
    
    var plant: Plant1? {
        didSet {
            updateViews()
        }
    }
    
    // CT Picker code for trying to select multiple days.. not working
    weak var ctDelegate: CTPickerDelegate?
    var dayArray:[String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


    
    // IB Outlets
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantNicknameTextField: UITextField!
    @IBOutlet weak var howManyPlantsTextField: UITextField!
    @IBOutlet weak var h2oFrequencyPerWeekTextLabel: UITextField!
    @IBOutlet weak var textWaterNotificationsToggleLbl: UILabel!
    @IBOutlet weak var wateringDaysPerWeek: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    // need to add model attribute for totalPlants - Int or String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ctDelegate = self
        wateringDaysPerWeek.delegate = self
         
    }
    
  

 // UpdateView
    
    private func updateViews() {
        guard isViewLoaded else { return } //check to see if views are there
        title = plant?.species ?? "Add a New Plant"
        
        plantSpeciesTextField.text = plant?.species
        plantNicknameTextField.text = plant?.nickname
//        howManyPlantsTextField.text = plant.howManyPlants  -- NEED to ADD in CoreData Model
        h2oFrequencyPerWeekTextLabel.text = plant?.h2oFrequencyPerWeek
        
    }
    
    
    //IB Actions
    @IBAction func textWaterNotficationsToggle(_ sender: Any) {
    }
    
    
    
    @IBAction func takePhotoBtnWasPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            //present photo picker
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take a Picture", style: .default) { (_) in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose a Photo", style: .default) { (_) in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        //added camera requirement in info.plist
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker,animated: true, completion: nil)
        
    }
    
    @IBAction func savePlantBtnWasPressed(_ sender: Any) {
        guard let species = plantSpeciesTextField.text,
            !species.isEmpty else { return }
        let nickname = plantNicknameTextField.text
        let waterFrequency = h2oFrequencyPerWeekTextLabel.text
       
        
        CoreDataStack.shared.mainContext.perform {
            if let plant = self.plant {
                //editing exiting plants
                plant.species = species
                plant.nickname = nickname
                plant.h2oFrequencyPerWeek = waterFrequency
                self.plantController.sendPlantToServer(plant: plant)
            } else {
                //create new plant object
                let plant = Plant1(nickname: nickname ?? "Unnamed Plant", species: species, h2oFrequencyPerWeek: waterFrequency ?? "2", startingDayOfWeek: "Sunday")
                self.plantController.sendPlantToServer(plant: plant)
            }
        }
 // Use persistent Store coordinator2
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Print Error Saving Plant: \(error)")
        }
        navigationController?.popViewController(animated: true)

    }
    
 
    
    // for CTPickerDelagate
    func setField(value: String, selectedTextField: UITextField, new: Bool) {
        selectedTextField.text = value
        //append
        if new {
            switch selectedTextField {
            case wateringDaysPerWeek:
                dayArray.append(value)
            default:
                break
            }
        }
       }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        switch textField {
        case wateringDaysPerWeek:
            CTPicker.presentCTPicker(on: self, textField: textField, items: dayArray)
        default:
            break
        }
      }
    
}


//Extension for UI Picker Camera

extension AddPlantsDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("No Image Returned")}
        imageView.image = image
        // Plant image is missing from CoreData - Have to add to save photo
    }
}
