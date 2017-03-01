//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    var repos: [GithubRepo]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()

        // Initialize the UITable
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 185
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            self.repos = newRepos
            self.tableView.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error!)
        })
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        doSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

// Table methods
extension RepoResultsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        let repo = repos[indexPath.row]
        cell.nameLabel.text = repo.name
        cell.starLabel.text = "\(repo.stars!)"
        cell.forkLabel.text = "\(repo.forks!)"
        cell.repoDescription.text = repo.repoDescription
        cell.ownerLabel.text = repo.ownerHandle

        let imageUrl = URL(string: repo.ownerAvatarURL!)
        let imageRequest = URLRequest(url: imageUrl!)

        cell.ownerAvator.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: {
                (imageRequest, imageResponse, image) -> Void in
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    //print("Image was NOT cached, fade in image")
                    cell.ownerAvator.alpha = 0.0
                    cell.ownerAvator.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        () -> Void in
                        cell.ownerAvator.alpha = 1.0
                    })
                }
                else {
                    //print("Image was cached so just update the image")
                    cell.ownerAvator.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                
            }
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = repos {
            return repos.count
        }
        return 0
    }
}

extension RepoResultsViewController: SettingsPresentingViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! SearchSettingsViewController
        vc.settings = searchSettings // ... Search Settings ...
        vc.delegate = self
    }

    func didSaveSettings(settings: GithubRepoSearchSettings) {
        self.searchSettings = settings
        dismiss(animated: true, completion: nil)
        doSearch()
    }
    
    func didCancelSettings() {
        dismiss(animated: true, completion: nil)
    }
}

