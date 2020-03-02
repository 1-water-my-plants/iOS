//
//  MyPlantsTableViewController.swift
//  Water My Plants
//
//  Created by Sal B Amer on 2/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class MyPlantsTableViewController: UITableViewController {
    
    var fakeDataController = FakeDataController()
    
    
    lazy var fetchedResultController: NSFetchedResultsController<FakeData> = {
        let fetchRequest: NSFetchRequest<FakeData> = FakeData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "plant", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "plant", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching CoreDataStack: \(error)")
        }
        
        return frc
    }()
    
    var fakePlants: [Fake] = [
        Fake(plant: "Potted Plants"),
        Fake(plant: "Garden Flowers"),
        Fake(plant: "Vegetable Garden"),
        Fake(plant: "Outdoor Trees"),
        Fake(plant: "Bushes"),
        Fake(plant: "Vines")
    ]
    
    var newArray: [FakeData] = []
    

    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add a plant", message: "Please enter the name of a plant.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your plant"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let plantString = alert.textFields?.first?.text else { return }
            let plants = String(plantString)
            self.fakeDataController.create(plant: plants)
            
            print(self.fakePlants.count)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .plantEntered, object: nil)
        updateViews()
    }
    
    @objc func updateViews() {
        fetchedResultController.fetchedObjects?.forEach({ plant in
            let plant = plant as FakeData
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        fetchedResultController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath)

        let plant = fetchedResultController.object(at: indexPath)
        
        cell.textLabel?.text = plant.plant
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyPlantsTableViewController: NSFetchedResultsControllerDelegate {
    
}
