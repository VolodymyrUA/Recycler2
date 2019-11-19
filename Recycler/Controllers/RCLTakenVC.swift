//
//  RCLTakenVC.swift
//  Recycler
//
//  Created by Ostin Ostwald on 3/13/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit

class RCLTakenVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellId = "RCLTakenCell"
    let nib = "RCLTakenCell"
    var trashList = [Trash]()
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: nib, bundle: nil ), forCellReuseIdentifier: cellId)
        FirestoreService.shared.getTrashbyStatus(status: .taken) { (trashList) in
            self.trashList = trashList
        }
    }
    
    func getUser(from id: String){
        FirestoreService.shared.getDocumentById(from: .users, returning: User.self, id: id) { user in
            self.user = user ?? self.user
            
        }
    }

  }

extension RCLTakenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  3 //userTrashCans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RCLTakenCell else {
            return UITableViewCell()
        }
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        cell.backgroundColor = UIColor.Backgrounds.GrayLight
        cell.selectionStyle = .none
        
//        cell.configureCell(forCan: userTrashCans[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getTrash(forTrashCan: userTrashCans[indexPath.row])
    }
    
}
