//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Diógenes Dauster on 8/18/19.
//  Copyright © 2019 Dauster. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {

    @IBOutlet weak var todoTextLabel: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
