//
//  ListOfFilmsTableViewController.swift
//  Yo.ListOfBestFilms
//
//  Created by Сергей on 18/10/2018.
//  Copyright © 2018 Sergei Kononov. All rights reserved.
//

import UIKit

class ListOfFilmsTableViewController: UITableViewController {
    
    var listOfFilms: [Film] = []
    var groupedFilms: [GroupedFilms] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        getFilms()
    }
    
    func getFilms() {
        NetworkManager.sharedInstance.getListOfFilms(success: { (films) in
            if films != nil {
                self.mappingFilms(list: films!)
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    
    func mappingFilms(list: [Film]) {
        for item in list {
            if !self.groupedFilms.contains(where: {$0.year == item.year}) {
                let temp = list.filter{$0.year == item.year}.sorted { (first, second) -> Bool in
                    if (first.rating! > second.rating!) {
                        return true
                    } else {
                        return false
                    }
                }
                self.groupedFilms.append(GroupedFilms(year: item.year, films: temp))
            } else {
                let index = self.groupedFilms.indices.first!
                self.groupedFilms[index].films.append(item)
            }
            
            self.groupedFilms.sort {$0.year < $1.year }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.groupedFilms.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = String(self.groupedFilms[section].year)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        return label
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupedFilms[section].films.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "films", for: indexPath) as! FilmsTableViewCell
        
        let item = self.groupedFilms[indexPath.section].films[indexPath.row]

        
        cell.name.text = item.localized_name
        cell.nativeName.text = item.name
        if item.rating! != 11 {
            cell.raiting.text = String(item.rating!)
        } else {
            cell.raiting.text = "No raiting"
        }

        return cell
    }

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destination = segue.destination as! DetailViewController
            if let indexPath = (tableView.indexPathForSelectedRow as IndexPath?) {
                destination.film = self.groupedFilms[indexPath.section].films[indexPath.row]
                destination.navigationItem.title = self.groupedFilms[indexPath.section].films[indexPath.row].localized_name
            }
        }
    }

}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
