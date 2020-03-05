//
//  ClassifierViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//
import UIKit
import CoreML
import Vision

class ClassifierViewController: UIViewController {
    
    //lazy var for classification
    lazy var classificationRequest: VNCoreMLRequest = {
        
        //do try block for model it throws
        do {
            //initialize model file then pull out model
            /// HAVE NOT  ADDE D MODEL YET 200MB
            let model = try VNCoreMLModel(for: FlowerClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            
            // process the classifcations/data from model
            self.processClassifications(for: request, error: error)
                
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to Load visionML Model: \(error)")
        }
        
    }()
    
    // process Classifications & data of CoreML model
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
                   guard let classifications = request.results as? [VNClassificationObservation] else {
                 self.classificationLbl.text = "Unable to classify the images.\n\(error?.localizedDescription ?? "Error")"
                 return
             }
             if classifications.isEmpty {
                 self.classificationLbl.text = "Nothing was recognized."
             } else {
                 //return top 2 classifications
                 let topClassifications = classifications.prefix(2)
                 let descriptions = topClassifications.map { classification in
                     return String(format: "%.2f", classification.confidence * 100) + "% - " + classification.identifier
                 }
                 self.classificationLbl.text = "Classifications:\n" + descriptions.joined(separator: "\n")
             }
        }
 
    }

    func updateClassifications(for image: UIImage) {
        classificationLbl.text = "Classifying Object..."
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)), let ciImage =
        CIImage(image: image) else {
            //display error
            displayError()
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perfom classification.\n\(error.localizedDescription ?? "Error")")
                return
            }
        }
        
    }
    
    func displayError() {
        classificationLbl.text = "Something went wrong...\nPlease Try again."
    }
    
    //ibOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLbl: UILabel!
    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
    
    
// IB Action
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            //present photo picker
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take a picture", style: .default) { (_) in
            //present photo picker with camera
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose a Photo", style: .default) { (_) in
            //present photo picker
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        // add privacy request + key in info.plist NSCameraUsageDescription
        
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true, completion: nil)
        
    }
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
        
    }
    

}

// after image is picked
extension ClassifierViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("No Image Returned") }
        //dont use fatalerrors in production
        imageView.image = image
        //use image to make prediction with coreML Model
        updateClassifications(for: image)
    }
}
