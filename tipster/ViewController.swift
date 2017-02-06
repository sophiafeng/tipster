//
//  ViewController.swift
//  tiptop
//
//  Created by Sophia Feng on 11/5/16.
//
//

import UIKit

class ViewController: UIViewController {
    
    struct tipSegment {
        static let low = 0
        static let med = 1
        static let high = 2
    }

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    var defaultTip : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        
        self.tipLabel.text = "$0.00"
        self.totalLabel.text = "$0.00"
        
        tipControl.layer.cornerRadius = 5.0
        tipControl.layer.masksToBounds = true
        tipControl.tintColor = UIColor(red: 92.0/255, green: 69.0/255, blue: 133.0/255, alpha: 0.8)
        tipControl.selectedSegmentIndex = 0
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(15, forKey: "lowTip")
        userDefaults.set(20, forKey: "medTip")
        userDefaults.set(25, forKey: "hiTip")
        userDefaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tipControl.setTitle(":(", forSegmentAt: tipSegment.low)
        tipControl.setTitle(":|", forSegmentAt: tipSegment.med)
        tipControl.setTitle(":)", forSegmentAt: tipSegment.high)
        
        calculateTip(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        let userDefaults = UserDefaults.standard
        let tipSelectedSegmentIndex = tipControl.selectedSegmentIndex
        var tipPercentage = userDefaults.integer(forKey: "lowTip")
        
        switch tipSelectedSegmentIndex {
        case tipSegment.low:
            tipPercentage = userDefaults.integer(forKey: "lowTip")
        case tipSegment.med:
            tipPercentage = userDefaults.integer(forKey: "medTip")
        case tipSegment.high:
            tipPercentage = userDefaults.integer(forKey: "hiTip")
        default:
            tipPercentage = userDefaults.integer(forKey: "hiTip")
        }
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentage) * 0.01
        let total = tip + bill
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

