//
//  RCLIssuesVC.swift
//  Recycler
//
//  Created by Roman Shveda on 3/14/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit

class RCLIssuesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellId = "RCLIssuesCell"
    let nib = "RCLIssuesCell"
    var trashList = [Trash]()
    var trashCanList = [TrashCan]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreService.shared.getDataForEmployer(status: .available) { (trashList, trashCanList, users) in
            self.trashList = trashList
            self.trashCanList = trashCanList
            self.users = users
            self.tableView.reloadData()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: nib, bundle: nil ), forCellReuseIdentifier: cellId)
    }
    
    private func viewSetup() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}

extension RCLIssuesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  trashList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RCLIssuesCell else {
            return UITableViewCell()
        }
//        tableView.estimatedRowHeight = 93
        tableView.rowHeight = 93
        cell.backgroundColor = UIColor.Backgrounds.GrayLight
        cell.selectionStyle = .none
        cell.configureCell(forCan: trashCanList[indexPath.row], forTrash: trashList[indexPath.row], forUser: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        getTrash(forTrashCan: userTrashCans[indexPath.row])
    }
}
