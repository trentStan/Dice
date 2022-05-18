//
//  Orange.swift
//  navTest
//
//  Created by IACD-022 on 2022/04/05.
//

import UIKit
import Charts
import FirebaseFirestore

class Orange: UIViewController {
    
    let db = Firestore.firestore().collection("Dice")
    
    var history: [Int] = []
    @IBOutlet var mean: UILabel!
    @IBOutlet var mode: UILabel!
    @IBOutlet var median: UILabel!
    
    @IBOutlet var chart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
        chart.xAxis.labelPosition = .bottom
        chart.lineData?.setValueFont(NSUIFont(name: "Arial", size: 15.0)!)
        
        chart.xAxis.decimals = 0
        chart.noDataText = "please roll dice at least once"
        chart.noDataTextAlignment = .center
        chart.noDataFont = .systemFont(ofSize: 27.0)
        
        db.document("Result").getDocument { (document, error) in
            if let document = document, document.exists {
                var set: [Int]?
                if document.data()!.count > 0 {
                    set = (document.data()!["History"]! as! [Int])
                } else{
                    set = []
                }
                
                
                print(set!)
                self.history = set!
                
                if self.history != []{
                self.mean.text = String(Int(self.mean(self.history)))
                self.mode.text = String(Int(self.mode(self.history)))
                self.median.text = String(Int(self.median(self.history)))
                    self.setData()
                    
                }
            } else {
                print("Document does not exist")
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearHistory(){
        db.document("Result").updateData(["History": FieldValue.delete()]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
            
            
            self.history = []
            
            self.mean.text = String(0)
            self.mode.text = String(0)
            self.median.text = String(0)
            self.setData()
        }
       
    }
    
    func setData(){
        
        var yValues: [ChartDataEntry] = []
        for (count, value) in history.enumerated() {
            
            yValues.append( ChartDataEntry(x: Double(count + 1), y: Double(value)))
            
        }
        let set1 = LineChartDataSet(entries: yValues, label: "last \(history.count) rolls")
        set1.circleRadius = 2
        set1.valueFont = .boldSystemFont(ofSize: 20)
        let data = LineChartData(dataSet: set1)
        
        chart.data = data
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
    }
    func mean(_ numbers: [Int]) -> Double {
        var sum = 0.0
        for number in numbers {
            sum += Double(number)
        }
        let mean = sum / Double(numbers.count)
        return mean.rounded()
    }
    
    func median(_ numbers: [Int]) -> Double {
        let sortedNumbers = numbers.sorted(by: { num1, num2 in
            return num1 < num2 })
        let midIndex = numbers.count / 2
        let median = Double(sortedNumbers[midIndex])
        return median
    }
    
    func mode(_ numbers: [Int]) -> Double {
        var occurrences: [Int : Int] = [:]
        for number in numbers {
            if let value = occurrences[number] {
                occurrences[number] = value + 1
            } else {
                occurrences[number] = 1
            }
            
            print(occurrences[number]!)
        }
        var highestPair: (key: Int, value: Int) = (0, 0)
        for (key, value) in occurrences {
            highestPair = (value > highestPair.value) ? (key, value) : highestPair
        }
        
        return Double(highestPair.key)
    }
    
}
