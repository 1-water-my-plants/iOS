//
//  MyPlantsTableViewController.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData


class MyPlantsTableViewController: UITableViewController {
    
    let plantController = PlantController()
    let apiController = APIController()
    let loginController = LoginController.shared
    var plant: Plant?
    
    @IBOutlet private var plantView1: UIImageView!
    @IBOutlet private var plantView2: UIImageView!
    @IBOutlet private var plantView3: UIImageView!
    
    
    /// Fetch results
    lazy var fetchedResultsController: NSFetchedResultsController<Plant1> = {
        let fetchRequest: NSFetchRequest<Plant1> = Plant1.fetchRequest()
        // must sort the fetch request otherwise crash
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "nickname", ascending: true),
            NSSortDescriptor(key: "species", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "nickname",
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching CoreDataStack: \(error)")
        }
        
        return frc
    }()
    
    
    func roundThePhotos() {
        plantView1.layer.cornerRadius = 15
        plantView2.layer.cornerRadius = 15
        plantView3.layer.cornerRadius = 15
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        roundThePhotos()
        tableView.reloadData()
        self.tableView.rowHeight = 100

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loginController.token?.token != nil {
            apiController.fetchAllPlants { result in
                if let createdPlants = try? result.get() {
                    DispatchQueue.main.async {
                        self.apiController.plants = createdPlants
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    

    // MARK: - Table view data source
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return fetchedResultsController.sections?.count ?? 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return apiController.plants.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlantsCell2", for: indexPath) as? MyPlantsTableViewCell else { return UITableViewCell() }
        let plant: Plant
        plant = apiController.plants[indexPath.row]
        
        var frequencyString = "Water me once a week"
        if plant.h2oFrequency ?? 0 > 1 {
             frequencyString = "Water me \(plant.h2oFrequency) times a week"
        }
        
        cell.plantNickname.text = plant.nickname.capitalized
        cell.waterFrequencyLabel.text = frequencyString
        
//        cell.plant = fetchedResultsController.object(at: indexPath)
//        let plant = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    // Forced to use this due to contraints bug
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

//  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            apiController.deletePlant { _ in
//                DispatchQueue.main.async {
//                    
//                }
//            }
//        }
//    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
// MARK: - Navigation

     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlantSegue" {
            if let MyPlantsVC = segue.description as? UINavigationController,
                let editVC = MyPlantsVC.topViewController as? EditPlantViewController {
                editVC.apiController = self.apiController
                editVC.plant = plant
            }
        }
    }
}


extension MyPlantsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            break

        }
    }
}
