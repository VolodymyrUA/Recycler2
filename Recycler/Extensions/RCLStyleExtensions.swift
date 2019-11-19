//
//  Styler.swift
//  testApp
//
//  Created by Ganna Melnyk on 3/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func styleButton() {
        self.backgroundColor = UIColor.Backgrounds.GrayLight
        self.tintColor = UIColor.Button.titleColor
        self.layer.cornerRadius = CGFloat.Design.CornerRadius
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
    }
}

extension UIImageView {
    func setRenderedImage(image: UIImage) {
        self.image = image
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.Font.White
    }
}

extension UIViewController {
    
    func addTitleLabel(text: String){
        let label = UILabel(frame: CGRect(x: 16, y: 21, width: 300, height: 32))
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.text = text
        label.textColor = UIColor.white
        self.view.addSubview(label)
    }
}

