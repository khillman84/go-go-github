//
//  RepoViewController.swift
//  GoGoGitHub
//
//  Created by Kyle Hillman on 4/4/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    var repos = [Repository]() {
        didSet {
            self.gitRepoList.reloadData()
        }
    }
    
    var displayRepos : [Repository]? {
        didSet {
            self.gitRepoList.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var gitRepoList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gitRepoList.dataSource = self
        self.gitRepoList.delegate = self
        self.searchBar.delegate = self
        
        let repoNib = UINib(nibName: "RepoNibCell", bundle: nil)
        self.gitRepoList.register(repoNib, forCellReuseIdentifier: RepoNibCell.identifier)
        
        self.gitRepoList.estimatedRowHeight = 50
        self.gitRepoList.rowHeight = UITableViewAutomaticDimension
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier {
            if let selectedIndex = self.gitRepoList.indexPathForSelectedRow?.row {
                let selectedRepo = self.repos[selectedIndex]
                
                guard let destinationController = segue.destination.transitioningDelegate as? RepoDetailViewController else { return }
                
                destinationController.repo = [selectedRepo]
            }
        }
    }
}

extension RepoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(duration: 1.0)
    }
}

extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  displayRepos?.count ?? repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoNibCell.identifier, for: indexPath) as! RepoNibCell
        
        let repo = self.repos[indexPath.row]
        
        cell.repo = repo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
    
}

//MARK: UISearchBar Delegate
extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.validate() {
            let lastIndex = searchText.index(before: searchText.endIndex)
            searchBar.text = searchText.substring(to: lastIndex)
        }
        
        if let searchedText = searchBar.text {
            self.displayRepos = self.repos.filter({$0.name.contains(searchedText)})
        }
        
        if searchBar.text == "" {
            self.displayRepos = nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.displayRepos = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}


























