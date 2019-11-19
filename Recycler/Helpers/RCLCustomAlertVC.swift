//
//  CustomAlertVC.swift
//  
//
//  Created by Ganna Melnyk on 3/13/18.
//

import UIKit

class RCLCustomAlertVC: UIViewController {

    @IBOutlet var errorTextLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorTextLabel.backgroundColor = UIColor.Backgrounds.GrayLight
        errorTextLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        errorTextLabel.layer.borderWidth = 1
        errorTextLabel.layer.cornerRadius = CGFloat.Design.CornerRadius
        submitButtonOutlet.backgroundColor = UIColor.Backgrounds.GrayLight
        submitButtonOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        submitButtonOutlet.layer.borderWidth = 1
        submitButtonOutlet.layer.cornerRadius = CGFloat.Design.CornerRadius
        mainView.backgroundColor = UIColor.Backgrounds.GrayDark
        mainView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainView.layer.borderWidth = 1
        mainView.layer.cornerRadius = CGFloat.Design.CornerRadius * 3
        
        
    }
    
    @IBAction func submitActionButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
