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
            segue.destination.transitioningDelegate = self
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoNames", for: indexPath)
        
//        let repo = self.repos[indexPath.row]
        cell.textLabel?.text = self.displayRepos?[indexPath.row].name ?? self.repos[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
    
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    func searchBArSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}


























