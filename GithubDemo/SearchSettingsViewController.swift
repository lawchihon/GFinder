//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by John Law on 28/2/2017.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(settings: GithubRepoSearchSettings)
    func didCancelSettings()
}

class SearchSettingsViewController: UITableViewController {
    weak var delegate: SettingsPresentingViewControllerDelegate?
    var settings = GithubRepoSearchSettings()

    @IBOutlet weak var starsSlider: UISlider!
    @IBOutlet weak var starsCount: UILabel!
    @IBOutlet var filterLanguageSwitch: UISwitch!
    @IBOutlet var controlCells: [UITableViewCell]!

    @IBOutlet var sortControl: UISegmentedControl!
    @IBOutlet var languagesCells: [UITableViewCell]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        starsSlider.setValue(Float(settings.minStars), animated: true)
        starsCount.text = "\(settings.minStars)"
        
        if settings.filterLanguages {
            filterLanguageSwitch.isOn = true
            showLanguages()
        }
        else {
            filterLanguageSwitch.isOn = false
            hiddenLanguages()
        }
        
        for controlCell in controlCells {
            controlCell.selectionStyle = .none
        }
        
        // Language Cell
        for index in 0...languagesCells.count-1 {
            languagesCells[index].selectionStyle = .none
            if settings.languages[index].1 {
                languagesCells[index].accessoryType = .checkmark
            }
            else {
                languagesCells[index].accessoryType = .none
            }
        }

        // Sort Control
        sortControl.selectedSegmentIndex = settings.sortSelect
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveButtonTapped(_ sender: Any) {
        print("saveButtonTapped")
        self.delegate?.didSaveSettings(settings: settings)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.delegate?.didCancelSettings()
    }

    @IBAction func editStars(_ sender: Any) {
        settings.minStars = Int(starsSlider.value)
        starsCount.text = "\(Int(starsSlider.value))"
    }
    
    func showLanguages() {
        for languageCell in languagesCells {
            languageCell.isHidden = false;
        }
    }
    
    func hiddenLanguages() {
        for languageCell in languagesCells {
            languageCell.isHidden = true;
        }
    }
    @IBAction func filterOrNot(_ sender: Any) {
        if filterLanguageSwitch.isOn {
            settings.filterLanguages = true
            showLanguages()
        }
        else {
            settings.filterLanguages = false
            hiddenLanguages()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickLanguageCell(cell: tableView.cellForRow(at: indexPath)!, row: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        clickLanguageCell(cell: tableView.cellForRow(at: indexPath)!, row: indexPath.row)
    }
    
    func clickLanguageCell(cell: UITableViewCell, row: Int) {
        if languagesCells.contains(cell) {
            if (cell.accessoryType == .checkmark) {
                print(row)
                settings.languages[row-1].1 = false
                print(settings.languages[row-1])
                cell.accessoryType = .none
            }
            else {
                settings.languages[row-1].1 = true
                cell.accessoryType = .checkmark
            }
        }
    }

    @IBAction func onSortControl(_ sender: Any) {
        settings.sortSelect = sortControl.selectedSegmentIndex
        
    }
}
