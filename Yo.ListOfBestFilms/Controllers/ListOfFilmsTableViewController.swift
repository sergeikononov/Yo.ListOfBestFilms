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
        
        refreshControl?.addTarget(self, action: #selector(self.refreshTable), for: UIControl.Event.valueChanged)
    }
    
    func getFilms() {
        NetworkManager.sharedInstance.getListOfFilms(success: { (films) in
            if films != nil {
                self.mappingFilms(list: films!)
                self.tableView.reloadData()
            }
        }) { (error) in
            showAlertWithOk(self, title: "Error", message: error)
        }
    }
    
    @objc func refreshTable(sender:AnyObject) {
        getFilms()
        refreshControl?.endRefreshing()
    }
    
    func mappingFilms(list: [Film]) {
        for item in list {
            if !self.groupedFilms.contains(where: {$0.year == item.year}) {
                let temp = list.filter { $0.year == item.year }.sorted { (first, second) -> Bool in
                    if first.rating! > second.rating! {
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "films", for: indexPath) as? FilmsTableViewCell {
            
            let item = self.groupedFilms[indexPath.section].films[indexPath.row]
            
            cell.name.text = item.localizedName
            cell.nativeName.text = item.name
            if item.rating! != 11 {
                cell.raiting.text = String(item.rating!)
            } else {
                cell.raiting.text = "No raiting"
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "films", for: indexPath)
            return cell
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let destination = segue.destination as? DetailViewController {
                if let indexPath = (tableView.indexPathForSelectedRow as IndexPath?) {
                    destination.film = self.groupedFilms[indexPath.section].films[indexPath.row]
                    destination.navigationItem.title = self.groupedFilms[indexPath.section].films[indexPath.row].localizedName
                } else {
                    return
                }
            }
        }
    }

}
