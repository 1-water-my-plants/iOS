//
//  MyPlantsTableViewCell.swift
//  Water My Plants
//
//  Created by Sal B Amer on 3/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class MyPlantsTableViewCell: UITableViewCell {
    
    let plantController = PlantController()
    
    var plant: Plant1? {
        didSet {
            updateViews()
        }
    }
    
    //IBOutlets
    @IBOutlet weak var plantNickname: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    private func updateViews() {
        guard let plant = plant else { return }
        plantNickname.text = plant.nickname
        // add image here 
        
    }
    
    //IB Actions for
    @IBAction func editPlant(_ sender: Any) {
    }
    @IBAction func plantNotifications(_ sender: Any) {
    }
    
}
