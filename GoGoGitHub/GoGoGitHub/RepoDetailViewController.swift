//
//  RepoDetailViewController.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/5/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    var repo = [Repository]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        let repoNib = UINib(nibName: "RepoNibCell", bundle: nil)
        self.tableView.register(repoNib, forCellReuseIdentifier: RepoNibCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension RepoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoNibCell.identifier, for: indexPath) as! RepoNibCell
        
        let repo = self.repo[indexPath.row]
        cell.repo = repo
        
        return cell
    }
}
