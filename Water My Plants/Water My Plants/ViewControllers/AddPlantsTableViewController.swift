//
//  AddPlantsTableViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class AddPlantsTableViewController: UITableViewController {
    
    let apiController = APIController()
    let loginController = LoginController.shared
    private let plantController = PlantController()
    
    
    /// Fetch results   //fo
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
    
    //end fetch results sal
    
    
    // Pull to refresh
    @IBAction func refresh(_ sender: Any) {
        plantController.fetchPlantsFromServer { _ in
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData), name: .plantDidSaveNotification, object: nil)
        tableView.reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loginController.token?.token != nil {
            apiController.fetchAllPlants { result in
                if let createdPlants = try? result.get() {
                    DispatchQueue.main.async {
                        self.apiController.plants = createdPlants
                        self.tableView.reloadData()
                        // having it in a viewWillAppear made them load in the tableview
                        // almost instantly so no waiting for the cells to
                        // populate
                    }
                }
            }
        }
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(apiController.plants.count)
//        return apiController.plants.count
        return apiController.plants.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlantCell", for: indexPath) as? AddPlantsTableViewCell else { return UITableViewCell() }
        
        let plant: Plant
        plant = apiController.plants[indexPath.row]
        
        cell.nicknameLabel?.text = plant.species.capitalized
//        cell.nicknameLabel?.text = plant.nickname?.capitalized
//        cell.detailTextLabel?.text = plantString

       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = fetchedResultsController.object(at: indexPath)
            plantController.deletePlantFromServer(task) { error in
                guard error == nil else {
                    print("Error Deleting task from server: \(error!)")
                    return
                }
                let moc = CoreDataStack.shared.mainContext
                moc.delete(task)
                
                do {
                    try moc.save()
                } catch {
                    moc.reset()
                    print("Error saving deleted task: \(error)")
                }
                
            }
             
        }
    }
  

    
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let plantVC = segue.destination as?
            PlantDetailViewController,
                let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
            plantVC.apiController = apiController
            plantVC.plant = apiController.plants[indexPath.row]
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           if segue.identifier == "AddPlantSegue" {
//               guard let AddPlantVC = segue.destination as? AddPlantsDetailsViewController else { return }
//               AddPlantVC.plantController = plantController
//           }
//       }
    
 

}

 extension AddPlantsTableViewController: NSFetchedResultsControllerDelegate {
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
