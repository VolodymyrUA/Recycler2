//
//  RCLAddTrashVC.swift
//  Recycler
//
//  Created by Yurii Tsymbala on 09.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit

class RCLAddTrashVC: UIViewController {
    
    private var locationFromDelegate = TrashLocation()
    
    private var locationPlaceholder = "Tap to add a location"
    
    private let sizeOfTrash = [RCLTrashSize.small, .medium, .large, .extraLarge]
    
    var trashLabelFromCatalogVC = ""
    
    var trashImageFromCatalogVC :UIImage?
    
    private var trashSizeFromPicker = RCLTrashSize.small
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var trashTableView: UITableView!
    
    @IBOutlet weak var typeOfTrashImage: UIImageView!
    
    @IBOutlet weak var typeOfTrashLabel: UILabel!
    
    @IBOutlet weak var orderTrashBtn: UIButton!
    
    @IBAction func orderTrashBtn(_ sender: UIButton) {
        if locationFromDelegate.name.count <= 0 {
            let titles = "Failed"
            let message = "Please add location"
            showAlert(titles, message)
            return
        }
        let trashCan = TrashCan(userId: currentUser.id!, address: locationFromDelegate.name, type: RCLTrashType(rawValue: trashLabelFromCatalogVC)!, size: trashSizeFromPicker)
        FirestoreService.shared.add(for: trashCan, in: .trashCan)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissPopUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func viewDesign(){
        view.backgroundColor = UIColor.Backgrounds.GrayDarkAlpha
        orderTrashBtn.backgroundColor = UIColor.darkModeratePink
        orderTrashBtn.layer.cornerRadius = CGFloat.Design.CornerRadius
        trashTableView.backgroundColor = UIColor.black
        popUpView.backgroundColor = UIColor.black
        popUpView.layer.cornerRadius = (CGFloat.Design.CornerRadius+2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
        trashTableView.reloadData()
        trashTableView.delegate = self
        trashTableView.dataSource = self
        typeOfTrashLabel.text = trashLabelFromCatalogVC
        typeOfTrashImage.image = trashImageFromCatalogVC
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTrashLocationSegue" {
            let mapVC = segue.destination as! RCLAddTrashLocationVC
            mapVC.trashLocationDelegate = self
        }
    }
}

extension RCLAddTrashVC: TrashLocationDelegate {
    
    func setLocation(location: TrashLocation) {
        locationFromDelegate = location
        self.trashTableView.reloadData()
    }
}

extension RCLAddTrashVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeOfTrash.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = String(describing: sizeOfTrash[row])
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}

extension RCLAddTrashVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = trashTableView.dequeueReusableCell(withIdentifier: "SizeTrashCell") as! RCLSizeViewCell
            cellDesign(cell: cell)
            return cell
        case 1:
            let cell = trashTableView.dequeueReusableCell(withIdentifier: "LocationTrashCell") as! RCLLocationViewCell
            cellDesign(cell: cell)
            if locationFromDelegate.name.count > 0 {
                cell.locationOfTrashLabel.text = locationFromDelegate.name
            } else {
                cell.locationOfTrashLabel.text = locationPlaceholder
            }
            return cell
        default:
            fatalError("you missed some cells")
        }
    }
    
    private func cellDesign(cell:UITableViewCell) {
        cell.backgroundColor = UIColor.black
    }
}

extension RCLAddTrashVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: "AddTrashLocationSegue", sender: self)
        default:
            return
        }
    }
}

extension RCLAddTrashVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(sizeOfTrash[row].rawValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        trashSizeFromPicker = sizeOfTrash[row]
    }
}

