//
//  EditPlantViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController {
    
    var plants: [Plant] = []
    var loginController = LoginController.shared
    var plant: Plant?
    var apiController: APIController?
    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet private var speciesTF: UITextField!
    @IBOutlet private var nicknameTF: UITextField!
    @IBOutlet private var wateringFrequencyTF: UITextField!
    @IBOutlet private var wateringDay: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        let waterFrequencyString = "\(self.plant?.h2oFrequency ?? 0)"
        
        self.title = "Edit \(plant.nickname)"
        self.wateringDay.text = "Friday"
        self.speciesTF.text = self.plant?.species
        self.nicknameTF.text = self.plant?.nickname
        self.wateringFrequencyTF.text = waterFrequencyString
    }
    
    func updatePlant(nickname: String,
                     species: String,
                     h2oFrequency: Int,
                     image: String,
                     completion: @escaping (Result<Plant, NetworkError>) -> Void) {
        
        let requestURL = self.loginController.baseURL.appendingPathComponent("/\(loginController.token?.user_id ?? 0)/plants/\(plant?.id ?? 0)")
        print(requestURL)
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        let updatedPlant = Plant(id: plant?.id ?? 0, nickname: nickname, species: species, h2oFrequency: h2oFrequency, image: image)
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(updatedPlant)
            request.httpBody = jsonData
        } catch {
            print("Error encoding updateObject: \(error.localizedDescription)")
            completion(.failure(.otherError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.badAuth))
                print(response.statusCode)
            }
            
            if error != nil {
                completion(.failure(.badData))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let plant = try decoder.decode(Plant.self, from: data)
                self.plants.append(plant)
                completion(.success(plant))
            } catch {
                print("Error decoding updated plant after updating: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard let _ = self.plant,
            let h2oFrequency = self.wateringFrequencyTF.text,
            let species = self.speciesTF.text,
            let nickname = self.nicknameTF.text,
            let image = self.wateringDay.text else { return }
        
        self.updatePlant(nickname: nickname, species: species, h2oFrequency: Int(h2oFrequency) ?? 0, image: image, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let plant):
                self.delegate?.updateModel(plant: plant)
            }
        })
        DispatchQueue.main.async {
            self.updateViews()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
// merge to master
