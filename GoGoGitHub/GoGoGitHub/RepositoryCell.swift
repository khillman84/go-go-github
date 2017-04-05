//
//  RepositoryCell.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/5/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var repoCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
