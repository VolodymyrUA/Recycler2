//
//  LoginVC.swift
//  testApp
//
//  Created by Ganna Melnyk on 3/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class RCLLoginVC: UIViewController, AuthServiceDelegate {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInOutlet: UIButton!
    @IBOutlet weak var signUpOutlet: UIButton!
    var image = #imageLiteral(resourceName: "logo")
    
    let customAlert = RCLCustomAlertVC(nibName: "RCLCustomAlertVC", bundle: nil)

    @IBAction func signInButton(_ sender: Any) {
        guard let login = loginTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        authentificator.login(login: login, password: password)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "ToSignUp", sender: self)
    }
    

//    var styler = RCLStyler()
    var authentificator = RCLAuthentificator()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Backgrounds.GrayDark
        authentificator.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        signInOutlet.styleButton()
        signUpOutlet.styleButton()
//        styler.styleButton(button: signInOutlet)
//        styler.styleButton(button: signUpOutlet)
        loginTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.textType = .emailAddress
        passwordTextField.textType = .password
        loginTextField.initialStyler()
        passwordTextField.initialStyler()
        logoImage.image = image
    }
    
    func alert(text: String) {
        customAlert.modalPresentationStyle = .overCurrentContext
        present(customAlert, animated: true, completion: nil)
        customAlert.errorTextLabel?.text = text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        authentificator.isAUserActive()
    }
    
    func transitionToCust() {
        performSegue(withIdentifier: "ToApp", sender: self)
    }
    
    func transitionToEmpl() {
        performSegue(withIdentifier: "ToEmp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToApp" {
            if let tabBar = segue.destination as? UITabBarController {
                tabBar.selectedIndex = 2
            }
        }
    }
}

extension RCLLoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
