//
//  AddPlantsTableViewCell.swift
//  Water My Plants
//
//  Created by Alex Thompson on 3/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class AddPlantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
