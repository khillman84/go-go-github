//
//  RepoViewController.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/4/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var repos = [Repository]() {
        didSet {
            self.gitRepoList.reloadData()
        }
    }
    
    @IBOutlet weak var gitRepoList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gitRepoList.dataSource = self
        self.gitRepoList.delegate = self
        
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
        GitHub.shared.getRepos { (repositories) in
            OperationQueue.main.addOperation {
                self.repos = repositories ?? []
                print(self.repos.count)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoNames", for: indexPath)
        
        let repo = self.repos[indexPath.row]
        cell.textLabel?.text = repo.name
        
        return cell
    }

}
