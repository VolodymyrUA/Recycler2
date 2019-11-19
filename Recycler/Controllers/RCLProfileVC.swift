//
//  RCLProfileVC.swift
//  Recycler
//
//  Created by Artem Rieznikov on 02.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RCLProfileVC: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var trashesTitle: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var phone: UITextField!
    
    let nib = "RCLProfileCell"
    let cellId = "RCLProfileCell"
    var isInEditMode = false
    var userTrashCans = [TrashCan]()
    var user = User()
    let database = FirestoreService.shared
    let formatter = RCLFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        setupDelegates()
        tableView.register(UINib(nibName: nib, bundle: nil ), forCellReuseIdentifier: cellId)
        profileView.addEgg()
        user = currentUser
        self.getTrashCans(forUser: self.user)
        self.updateInfo(with: self.user)
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        phone.delegate = self
        firstName.delegate = self
        lastName.delegate = self
    }
    
    
    private func viewSetup() {
        addTitleLabel(text: "Profile")
        navigationController?.isNavigationBarHidden = true
        
        //profileTitle.textColor = UIColor.Font.White
        firstName.textColor = UIColor.Font.White
        lastName.textColor = UIColor.Font.White
        phoneTitle.textColor = UIColor.Font.Gray
        phone.textColor = UIColor.Font.Gray
        trashesTitle.textColor = UIColor.Font.White
        
        phone.textType = .phone
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        self.view.backgroundColor = UIColor.Backgrounds.GrayDark
        self.tableView.backgroundColor = UIColor.Backgrounds.GrayDark
        profileView.backgroundColor = UIColor.Backgrounds.GrayLight
        profileView.layer.cornerRadius = CGFloat.Design.CornerRadius
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let alertView = UIAlertController(title: "Warning!", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            self.logOut()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            return
        }
        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
    }
    @IBAction func editProfile(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        isInEditMode = sender.isSelected
        firstName.isUserInteractionEnabled = isInEditMode
        lastName.isUserInteractionEnabled = isInEditMode
        phone.isUserInteractionEnabled = isInEditMode
        
        if isInEditMode {
            firstName.becomeFirstResponder()
        } else {
            firstName.resignFirstResponder()
            saveNewData()
        }
    }
    
    private func logOut() {
        RCLAuthentificator.signOut()
        let st = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = st.instantiateViewController(withIdentifier: "LoginVC") as? RCLLoginVC else {
            return
        }
        self.present(loginVC, animated: true, completion: nil)
    }
    
    private func saveNewData() {
        user.firstName = firstName.text!
        user.lastName = lastName.text!
        user.phoneNumber = phone.text!
        database.update(for: user, in: .users)
    }
    
    private func updateInfo(with user: User) {
        self.firstName.text = user.firstName
        self.lastName.text = user.lastName
        self.phone.text = user.phoneNumber
    }
    
    private func getTrashCans(forUser: User) {
        database.getTrashCansBy(userId: forUser.id!) { result in
            self.userTrashCans = result
            self.tableView.reloadData()
        }
    }
    
    private func getTrash(forTrashCan: TrashCan) {
        database.getLatestTrashBy(trashCanId: forTrashCan.id!) { trash in
            print(trash?.dateReportedFull.description)
        }
    }
}

extension RCLProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTrashCans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RCLProfileCell else {
            return UITableViewCell()
        }
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        cell.backgroundColor = UIColor.Backgrounds.GrayLight
        cell.selectionStyle = .none
        
        cell.configureCell(forCan: userTrashCans[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getTrash(forTrashCan: userTrashCans[indexPath.row])
    }
}

extension RCLProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == phone) && textField.text?.count == 0 {
            textField.text = "+38("
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.styleTextField()
        if (textField == phone) && textField.text?.count == 4 {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.borderStyle = .none
        
        if (textField == phone) {
            let decimalString = formatter.decimalFormatter(text: textField.text!, range: range, replacementString: string)
            let length = decimalString.length
            if length == 0 || length > 12 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                return (newLength > 11) ? false : true
            }
            textField.text = formatter.formatString(text: decimalString, length: length)
            textField.styleTextField()
            editProfile.isEnabled = textField.valid
            return false
        } else {
            let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            if text.count >= 3 {
                editProfile.isEnabled = true
                textField.backgroundColor = UIColor.clear
            } else {
                editProfile.isEnabled = false
                textField.backgroundColor = UIColor.red
            }
            return text.count <= 16
        }
    }
}

