//
//  RCLDashboardVC.swift
//  Recycler
//
//  Created by Artem Rieznikov on 02.03.18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit
import PieCharts

struct TotalSizes {
    var plastic = 0
    var metal = 0
    var organic = 0
    var batteries = 0
    var glass = 0
    var paper = 0
    var unknown = 0
}

class RCLDashboardVC: UIViewController {
    
    let chartView: PieChart = PieChart(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(chartView)
        addLabel()
        buttonCreate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
   func buttonCreate() {
    
    let button = UIButton(type: UIButtonType.system) as UIButton
    
    let xPostion:CGFloat = 120
    let yPostion:CGFloat = 550
    let buttonWidth:CGFloat = 150
    let buttonHeight:CGFloat = 45
    
    button.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
    
    button.backgroundColor = UIColor.Button.backgroundColor
    button.setTitle("Statistic", for: UIControlState.normal)
    button.layer.cornerRadius = CGFloat.Design.CornerRadius
    button.tintColor = UIColor.Button.titleColor
    button.addTarget(self, action: #selector(RCLDashboardVC.buttonAction(_:)), for: .touchUpInside)
    self.view.addSubview(button)
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        performSegue(withIdentifier: "StatisticsSegue", sender: self)
        print("Button tapped")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        chartView.backgroundColor = UIColor.Backgrounds.GrayDark
        chartView.layers = [createCustomViewsLayer(), createTextLayer()]
        
        chartView.models = createModels() // order is important - models have to be set at the end
        
//        print(currentUser)
    }
    
    //  MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        // print("Selected: \(selected), slice: \(slice)")
    }
    
    // MARK: - Models
//    @IBAction func signOutButton(_ sender: UIButton) {
//        RCLAuthentificator.signOut()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let next = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! RCLLoginVC
//        self.present(next, animated: true, completion: nil)
//        print("logout tapped")
//    }
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        
        return [
            PieSliceModel(value: 2.1, color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: 3, color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: 0.3, color: UIColor.orange.withAlphaComponent(alpha)),
            PieSliceModel(value: 0.5, color: UIColor.purple.withAlphaComponent(alpha)),
            PieSliceModel(value: 0.9, color: UIColor.gray.withAlphaComponent(alpha)),
        ]
    }
    
    //  MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 75
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                   // specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.blue
                   // specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            let imageName: String? = {
                switch slice.data.id {

                case 0: return "trash_organic"
                case 1: return "trash_batteries"
                case 2: return "trash_glass"
                case 3: return "trash_paper"
                case 4: return "trash_metal"
                case 5: return "trash_plastic"
                
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            view.contentMode = .scaleAspectFit
            
            return container
        }
    }
    //    MARK: - dn - label
    func addLabel(){
        let label = UILabel(frame: CGRect(x: 16, y: 21, width: 300, height: 32))
        //        let lblNew = UILabel()
        //        lblNew.backgroundColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.text = "Dashboard"
        label.textColor = UIColor.white
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.constraints.
        view.addSubview(label)
    }

    func getTrashCansTotalSize(trashCans: [TrashCan]) -> TotalSizes {
        var result = TotalSizes()
        for trashCan in trashCans {
            switch trashCan.type {
            case "plastic" :
                result.plastic += trashCan.size
            case "metal" :
                result.metal += trashCan.size
            case "organic" :
                result.organic += trashCan.size
            case "battaries" :
                result.batteries += trashCan.size
            case "glass" :
                result.glass += trashCan.size
            case "paper" :
                result.paper += trashCan.size
            default:
                result.unknown += trashCan.size
            }
        }
        return result
    }

}
