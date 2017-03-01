//
//  GithubRepoSearchSettings.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation

// Model class that represents the user's search settings
class GithubRepoSearchSettings {
    var searchString: String?
    var minStars = 0
    var filterLanguages = false
    var languages = [("Java", true), ("JavaScript", true), ("Objective-C", true), ("Ruby", true), ("Python", true), ("Swift", true)] as [(String, Bool)]
    var sorts = ["stars", "forks", "updated"] as [String]
    var sortSelect = 0
    
    init() {
    }
}
