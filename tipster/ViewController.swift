//
//  ViewController.swift
//  tipster
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
    @IBOutlet weak var tipSymbol: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTwoLabel: UILabel!
    @IBOutlet weak var totalThreeLabel: UILabel!
    @IBOutlet weak var totalFourLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentControl: SegmentedControl!
    @IBOutlet weak var splitOne: UILabel!
    @IBOutlet weak var splitTwo: UILabel!
    @IBOutlet weak var splitThree: UILabel!
    @IBOutlet weak var splitFour: UILabel!
    @IBOutlet weak var tipsterLabel: UILabel!
    
    var defaultTip : Int?
 
    // MARK: - UIViewController fns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        
        self.tipLabel.text = "$0.00"
        self.totalLabel.text = "$0.00"
        self.totalTwoLabel.text = "$0.00"
        self.totalThreeLabel.text = "$0.00"
        self.totalFourLabel.text = "$0.00"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.billField.becomeFirstResponder()
        
        tipPercentControl.layer.masksToBounds = true
        tipPercentControl.selectedIndex = 0
        
        self.addDoneButtonOnKeyboard()
        
        self.view.backgroundColor = UIColor(red:0.44, green:0.75, blue:0.91, alpha:1.0)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(15, forKey: "lowTip")
        userDefaults.set(20, forKey: "medTip")
        userDefaults.set(25, forKey: "hiTip")
        userDefaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bill = Double(billField.text!) ?? 0
        if bill == 0 {
            self.tipLabel.isHidden = true
            self.tipPercentControl.isHidden = true
            self.tipSymbol.isHidden = true
            self.totalLabel.isHidden = true
            self.totalTwoLabel.isHidden = true
            self.totalThreeLabel.isHidden = true
            self.totalFourLabel.isHidden = true
            self.splitOne.isHidden = true
            self.splitTwo.isHidden = true
            self.splitThree.isHidden = true
            self.splitFour.isHidden = true
            self.billField.frame.origin.y = 292
        } else {
            self.billField.frame.origin.y = 190
            calculateTip(self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIStateRestoring protocol methods
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(String(describing: NSDate()), forKey: "savedTimestampKey")
        if let billTextFieldData = billField.text {
            coder.encode(billTextFieldData, forKey: "billTextField")
        }
        coder.encode(String(tipPercentControl.selectedIndex), forKey: "tipSelector")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        var restore = false
        
        // Only restore states if elapsed time is more than 10 minutes
        if let savedTimestampString = coder.decodeObject(forKey: "savedTimestampKey") as? String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ssZZZ"
            let savedTimestamp = dateFormatter.date(from: savedTimestampString)
            let elapsedTime = NSDate().timeIntervalSince(savedTimestamp!)
            let elapsedTimeInMins = elapsedTime / 60
            if elapsedTimeInMins < 10 {
                restore = true
            }
        }
        
        if (restore) {
            if let billTextFieldData = coder.decodeObject(forKey: "billTextField") as? String {
                billField.text = billTextFieldData
            }
            if let tipPercentageControlSelectedIndex = coder.decodeObject(forKey: "tipSelector") as? String {
                tipPercentControl.selectedIndex = Int(tipPercentageControlSelectedIndex)!
            }
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))
        
        doneToolbar.items = [done]
        doneToolbar.sizeToFit()
        
        self.billField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.billField.resignFirstResponder()
    }
    
    // MARK: - Tip calculation fns

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onEditingBegin(_ sender: Any) {
        print("editing begin")
        fadeOutControls()
        scaleUpBill()
        
        animateBackgroundColor(with: UIColor(red:0.44, green:0.75, blue:0.91, alpha:1.0))
    }
    
    @IBAction func onEditingEnd(_ sender: Any) {
        print("editing end")
        scaleDownBill()
        
        let bill = Double(billField.text!) ?? 0
        if bill > 0 {
            fadeInControls()
            calculateTip(self)
        } else {
            fadeInTipsterLabel()
        }
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        let userDefaults = UserDefaults.standard
        let tipPercentSelectedIndex = tipPercentControl.selectedIndex
        var tipPercentage = userDefaults.integer(forKey: "lowTip")
        
        switch tipPercentSelectedIndex {
        case tipSegment.low:
            tipPercentage = userDefaults.integer(forKey: "lowTip")
            animateBackgroundColor(with: UIColor(red:0.62, green:0.28, blue:0.28, alpha:1.0))
        case tipSegment.med:
            tipPercentage = userDefaults.integer(forKey: "medTip")
            animateBackgroundColor(with: UIColor(red:0.69, green:0.67, blue:0.32, alpha:1.0))
        case tipSegment.high:
            tipPercentage = userDefaults.integer(forKey: "hiTip")
            animateBackgroundColor(with: UIColor(red:0.40, green:0.62, blue:0.28, alpha:1.0))
        default:
            tipPercentage = userDefaults.integer(forKey: "medTip")
        }
        
        let bill = Double(billField.text!) ?? 0
        let tip = bill * Double(tipPercentage) * 0.01
        let total = tip + bill
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        totalTwoLabel.text = String(format: "$%.2f", total / 2)
        totalThreeLabel.text = String(format: "$%.2f", total / 3)
        totalFourLabel.text = String(format: "$%.2f", total / 4)
    }
    
    // MARK: - Animation
    func scaleUpBill() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.billField.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.billField.frame.origin.y = 40
        })
    }
    
    func scaleDownBill() {
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: { () -> Void in
            self.billField.transform = CGAffineTransform(scaleX: 1, y: 1)
            let bill = Double(self.billField.text!) ?? 0
            if bill == 0 {
                self.billField.frame.origin.y = 292
            } else {
                self.billField.frame.origin.y = 190
            }
            
        })
    }
    
    func fadeOutControls() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.tipLabel.alpha = 0
            self.tipPercentControl.alpha = 0
            self.tipSymbol.alpha = 0
            self.totalLabel.alpha = 0
            self.totalTwoLabel.alpha = 0
            self.totalThreeLabel.alpha = 0
            self.totalFourLabel.alpha = 0
            self.splitOne.alpha = 0
            self.tipsterLabel.alpha = 0
            self.splitTwo.alpha = 0
            self.splitThree.alpha = 0
            self.splitFour.alpha = 0
        }, completion: { (True) -> Void in
            self.tipLabel.isHidden = true
            self.tipPercentControl.isHidden = true
            self.tipSymbol.isHidden = true
            self.totalLabel.isHidden = true
            self.totalTwoLabel.isHidden = true
            self.totalThreeLabel.isHidden = true
            self.totalFourLabel.isHidden = true
            self.splitOne.isHidden = true
            self.tipsterLabel.isHidden = true
            self.tipsterLabel.isHidden = true
            self.splitTwo.isHidden = true
            self.splitThree.isHidden = true
            self.splitFour.isHidden = true
        })
    }
    
    func fadeInControls() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: { () -> Void in
            self.tipLabel.alpha = 1
            self.tipPercentControl.alpha = 1
            self.tipSymbol.alpha = 1
            self.totalLabel.alpha = 1
            self.totalTwoLabel.alpha = 1
            self.totalThreeLabel.alpha = 1
            self.totalFourLabel.alpha = 1
            self.splitOne.alpha = 1
            self.tipsterLabel.alpha = 1
            self.splitTwo.alpha = 1
            self.splitThree.alpha = 1
            self.splitFour.alpha = 1
            self.tipLabel.isHidden = false
            self.tipPercentControl.isHidden = false
            self.tipSymbol.isHidden = false
            self.totalLabel.isHidden = false
            self.totalTwoLabel.isHidden = false
            self.totalThreeLabel.isHidden = false
            self.totalFourLabel.isHidden = false
            self.splitOne.isHidden = false
            self.tipsterLabel.isHidden = false
            self.splitTwo.isHidden = false
            self.splitThree.isHidden = false
            self.splitFour.isHidden = false
        }, completion: { (True) -> Void in })
    }
    
    func fadeInTipsterLabel() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: { () -> Void in
            self.tipsterLabel.alpha = 1
            self.tipsterLabel.isHidden = false
        }, completion: { (True) -> Void in })
    }
    
    func animateBackgroundColor(with color: UIColor) {
        UIView.animate(withDuration: 0.2, delay: 0.6, options: [], animations: { () -> Void in
            self.view.backgroundColor = color
        }, completion: { (True) -> Void in })
    }
    
}

