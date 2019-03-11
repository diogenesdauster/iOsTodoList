//
//  CheckmarkTableViewCell.swift
//  TodoList
//
//  Created by Diogenes Dauster on 3/6/19.
//  Copyright © 2019 Diogenes Dauster. All rights reserved.
//

import UIKit

class CheckmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmark: UILabel!
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
