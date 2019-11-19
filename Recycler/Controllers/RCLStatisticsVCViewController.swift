//
//  RCLStatisticsVCViewController.swift
//  Recycler
//
//  Created by Володимир Смульський on 3/15/18.
//  Copyright © 2018 softserve.university. All rights reserved.
//

import UIKit
import Charts

class RCLStatisticsVCViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    func date() -> Date {
        let date = Date()
        var components = DateComponents()
        let calendar = Calendar.current
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = calendar.component(.day, from: date) - 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let newDate = calendar.date(from: components)
        print("Date  \(newDate!)!!!!!!!!!")
        FirestoreService.shared.getTrashBy(oneDay: newDate!) { trashList in
            print(trashList.count)
        }
        return newDate ?? Date()
    }
    var numbersForPlastic : [Double] = [3,4,9,2,10,17]
    var numbersForPaper : [Double] = [7,10,15,2,10,11]
    var numbersForMetal : [Double] = [13,4,0,2,1,25]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date()
        
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"naxyi", style:.plain, target:nil, action:nil)
        updateGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGraph(){
        //this is the Array that will eventually be displayed on the graph.
        var lineChartEntry  = [ChartDataEntry]()
        var lineChartEntry2  = [ChartDataEntry]()
        var lineChartEntry3  = [ChartDataEntry]()
        for i in 0..<numbersForPlastic.count {
            let value = ChartDataEntry(x: Double(i), y: numbersForPlastic[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        for i in 0..<numbersForPaper.count {
            let value = ChartDataEntry(x: Double(i ), y: numbersForPaper [i]) // here we set the X and Y status in a data chart entry
            lineChartEntry2.append(value) // here we add it to the data set
        }
        
        for i in 0..<numbersForMetal.count {
            let value = ChartDataEntry(x: Double(i ), y: numbersForMetal[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry3.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Plastic") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        line1.valueTextColor = NSUIColor.blue
        
        let line2 = LineChartDataSet(values: lineChartEntry2, label: "Paper") //Here we convert lineChartEntry to a LineChartDataSet
        line2.colors = [NSUIColor.yellow]
        
        let line3 = LineChartDataSet(values: lineChartEntry3, label: "Metal")
        line3.colors = [NSUIColor.red]
        
        //let data = LineChartData() //This is the object that will be added to the chart
        
        let data = LineChartData()
        data.addDataSet(line1) //Adds the line to the dataSet
        data.addDataSet(line2)
        data.addDataSet(line3)
        
        lineChartView.data = data //finally - it adds the chart data to the chart and causes an update
        // lineChartView.chartDescription?.text = " " // Here we set the description for the graph
    }
    
}
