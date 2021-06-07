//
//  TableViewController.swift
//  Cards
//
//  Created by Дмитрий Головин on 26.05.2021.
//

import UIKit

class TableViewController: UITableViewController {
    var settings = Settings.shared
    var sections: [Int] = [1,2,3,4]
    var colors = CardColor.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SettingSections.allCases[section] {
        case .cardsCount:
            return 1
        case .cardsColor:
            return 9
        case .cardsBackType:
            return 2
        case .cardsFrontType:
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "colorType", for: indexPath)
            cell.textLabel?.text = CardColor.allCases[indexPath.row].rawValue
            
        } else if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cardCountCell", for: indexPath)
        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "backSideCardType", for: indexPath)
            cell.textLabel?.text = cardsBackType.allCases[indexPath.row].rawValue
        } else if indexPath.section == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "frontSideCardType", for: indexPath)
            cell.textLabel?.text = cardsFrontType.allCases[indexPath.row].rawValue
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch indexPath.section {
        case 0:
            cell?.isSelected = false
        case 1:
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
            }
            cell?.isSelected = false
        case 2:
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
            }
            cell?.isSelected = false
        case 3:
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
            } else {
                cell?.accessoryType = .checkmark
            }
            cell?.isSelected = false
        default:
            break
        }
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
