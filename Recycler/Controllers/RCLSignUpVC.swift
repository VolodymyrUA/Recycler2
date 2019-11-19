//
//  SingUpVC.swift
//  testApp
//
//  Created by Ganna Melnyk on 3/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class RCLSignUpVC: UIViewController, AuthServiceDelegate {
    
    @IBOutlet weak var firstAndLastNameUIImageView: UIImageView!
    @IBOutlet weak var passwordUIImageView: UIImageView!
    @IBOutlet weak var passwordConfirmationUIImageView: UIImageView!
    @IBOutlet weak var phoneUIImageView: UIImageView!
    @IBOutlet weak var emailUIImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    let customAlert = RCLCustomAlertVC(nibName: "RCLCustomAlertVC", bundle: nil)
    
    var formatter = RCLFormatter()
    var authentificator = RCLAuthentificator()
    var isAllFieldsValid = true
    
    var namesImage = #imageLiteral(resourceName: "avatar-1")
    var passwordImage = #imageLiteral(resourceName: "padlock")
    var phoneImage = #imageLiteral(resourceName: "phone-call")
    var emailImage = #imageLiteral(resourceName: "envelope")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentificator.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        self.view.backgroundColor = UIColor.Backgrounds.GrayDark
        delegates()
        styleViews()
        addTitleLabel(text: "Registration")
    }
    
    func delegates() {
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmationPasswordTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        
    }
    
    func styleViews() {
        firstAndLastNameUIImageView.setRenderedImage(image: namesImage)
        passwordUIImageView.setRenderedImage(image: passwordImage)
        passwordConfirmationUIImageView.setRenderedImage(image: passwordImage)
        phoneUIImageView.setRenderedImage(image: phoneImage)
        emailUIImageView.setRenderedImage(image: emailImage)
        backButtonOutlet.styleButton()
        loginButtonOutlet.styleButton()
        nameTextField.textType = .generic
        lastNameTextField.textType = .generic
        passwordTextField.textType = .password
        confirmationPasswordTextField.textType = .password
        phoneTextField.textType = .phone
        emailTextField.textType = .emailAddress
        nameTextField.initialStyler()
        lastNameTextField.initialStyler()
        passwordTextField.initialStyler()
        confirmationPasswordTextField.initialStyler()
        phoneTextField.initialStyler()
        emailTextField.initialStyler()
    }
    
    func styleTextField() {
        nameTextField.styleTextField()
        lastNameTextField.styleTextField()
        passwordTextField.styleTextField()
        confirmationPasswordTextField.styleTextField()
        phoneTextField.styleTextField()
        emailTextField.styleTextField()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if validator {
            authentificator.createUser(userName: nameTextField.text!, userLastName: lastNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!)
        } else {
            alert(text: "please, fill all fields correctly")
        }
    }
    
    func alert(text: String) {
        customAlert.modalPresentationStyle = .overCurrentContext
        present(customAlert, animated: true, completion: nil)
        customAlert.errorTextLabel?.text = text
    }
    
    func transitionToCust() {
        performSegue(withIdentifier: "ToApp", sender: self)
    }
    
    func transitionToEmpl() {
        performSegue(withIdentifier: "ToApp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToApp" {
            if let tabBar = segue.destination as? UITabBarController {
                tabBar.selectedIndex = 4
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if self.navigationController?.popToRootViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var validator: Bool {
        get {
            styleTextField()
            var isAllFieldsValid: Bool = true
            isAllFieldsValid = isAllFieldsValid && nameTextField.valid
            isAllFieldsValid = isAllFieldsValid && lastNameTextField.valid
            isAllFieldsValid = isAllFieldsValid && passwordTextField.valid
            isAllFieldsValid = isAllFieldsValid && confirmationPasswordTextField.valid
            isAllFieldsValid = isAllFieldsValid && phoneTextField.valid
            isAllFieldsValid = isAllFieldsValid && emailTextField.valid
            if confirmationPasswordTextField.text != passwordTextField.text {
                confirmationPasswordTextField.backgroundColor = UIColor.TextFieldBackGrounds.BackgroundForFalse
                isAllFieldsValid = false
            }
            return isAllFieldsValid
        }
    }
}

extension RCLSignUpVC: UITextFieldDelegate {
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
        textField.initialStyler()
        if (textField == phoneTextField) && textField.text?.count == 0 {
            textField.text = "+38("
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.styleTextField()
        if (textField == phoneTextField) && textField.text?.count == 4 {
            textField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isAllFieldsValid = true
        if (textField == phoneTextField) {
            let decimalString = formatter.decimalFormatter(text: textField.text!, range: range, replacementString: string)
            let length = decimalString.length
            if length == 0 || length > 12 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                return (newLength > 11) ? false : true
            }
            textField.text = formatter.formatString(text: decimalString, length: length)
            textField.styleTextField()
            return false
        } else {
            textField.styleTextField()
            return true
        }
    }
}

