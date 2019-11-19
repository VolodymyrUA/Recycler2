//
//  EasterEgg.swift
//  Recycler
//
//  Created by David on 3/15/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import Foundation
import UIKit

class EasterEgg: UIViewController {
    
    @objc func addEgg(number: Int) {
        let newView = UIView()
        newView.frame = self.view.frame
        newView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        let images = EggsStruct().getEggs(number: 4)
        
        let frameH = self.view.frame.height
        let frameW = self.view.frame.width
        
        for index in 0..<images.count {
            let imageView = UIImageView(image: images[index])
            imageView.tag = index
            let tap = UITapGestureRecognizer(target: imageView, action: #selector(removeView))
            imageView.addGestureRecognizer(tap)
            imageView.frame = CGRect(x: frameW - 20*CGFloat(index), y: frameH - 40*CGFloat(index), width: 40.0, height: 40.0)
            newView.addSubview(imageView)
            UIApplication.shared.keyWindow?.addSubview(newView)
        }
    }
    
    @objc private func removeView() {
        let view = self.view.viewWithTag(1)
        view?.removeFromSuperview()
    }
}


extension UIView {
    func addEgg() {
        let del = UIApplication.shared.delegate as? AppDelegate
        guard let target = del?.egg else {
            print("cannot find target")
            return
        }
        let tap = UITapGestureRecognizer(target: target, action: #selector(target.addEgg))
        tap.numberOfTapsRequired = 3
        self.addGestureRecognizer(tap)
    }
}

extension UIImageView {
    @objc func removeView() {
        self.removeFromSuperview()
    }
}
