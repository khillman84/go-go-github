//
//  RepoNibCell.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/5/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class RepoNibCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var language: UILabel!
    
    var repo : Repository! {
        didSet {
            self.projectName.text = repo.name
            self.repoDescription.text = repo.description
            self.language.text = repo.language
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
