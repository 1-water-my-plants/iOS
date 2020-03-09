//
//  PlantDetailViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func updateModel(plant: Plant)
}
class PlantDetailViewController: UIViewController {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet private var waterFrequencyLabel: UILabel!
    @IBOutlet private var waterDay: UILabel!
    var waterDay1 = AddPlantsDetailsViewController()
    
    var apiController = APIController()
    var loginController = LoginController.shared
    var plant: Plant?
    var plant1 = AddPlantsDetailsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        guard let plant = self.plant else { return }
        
        self.title = plant.species.uppercased()
        let frequencyString = "I like to be watered \(plant.h2oFrequency) time(s) a week."
        self.waterFrequencyLabel.text = frequencyString
        self.nicknameLabel.text = "My nickname is \(plant.nickname.capitalized)"
        self.waterDay.text = "I like to be watered on Friday's."
    }
    
    func deletePlant(completion: @escaping (Result<Plant, NetworkError>) -> Void) {
        guard let plant = self.plant else { return }
        
        let requestURL = apiController.baseURL.appendingPathComponent("/\(loginController.token?.user_id ?? 0)/plants/\(plant.id)")
       
        
        var request = URLRequest(url: requestURL)
        print(requestURL)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(loginController.token?.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 204 {
                completion(.failure(.badAuth))
                print(response.statusCode)
            }
            
            if error != nil {
                completion(.failure(.otherError))
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let plant = try decoder.decode(Plant.self, from: data)
                completion(.success(plant))
                print("I tried to delete something")
            } catch {
                print("Error decoding plant after deleting: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.deletePlant { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            if let nc = segue.destination as? UINavigationController,
                let editVC = nc.topViewController as? EditPlantViewController {
                editVC.apiController = self.apiController
                editVC.plant = plant
            }
        }
    }
}

extension PlantDetailViewController: DetailViewControllerDelegate {
    func updateModel(plant: Plant) {
        DispatchQueue.main.async {
            self.plant = plant
        }
    }
}
