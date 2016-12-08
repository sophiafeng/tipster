//
//  SettingsViewController.swift
//  tiptop
//
//  Created by Sophia Feng on 11/6/16.
//
//

import UIKit

class SettingsViewController: UIViewController {
    
    enum tipPercentageAdjustment {
        case decreaseLowTipPercentage
        case decreaseMedTipPercentage
        case decreaseHiTipPercentage
        case increaseLowTipPercentage
        case increaseMedTipPercentage
        case increaseHiTipPercentage
    }
    
    struct tipPercentagesConstant {
        static let low = 18
        static let med = 22
        static let hi = 23
    }

    @IBOutlet weak var lowTipPercentageLabel: UILabel!
    @IBOutlet weak var medTipPercentageLabel: UILabel!
    @IBOutlet weak var hiTipPercentageLabel: UILabel!
    @IBOutlet weak var decreaseLowTipPercentageButton: UIButton!
    @IBOutlet weak var increaseLowTipPercentageButton: UIButton!
    @IBOutlet weak var decreaseMedTipPercentageButton: UIButton!
    @IBOutlet weak var increaseMedTipPercentageButton: UIButton!
    @IBOutlet weak var decreaseHiTipPercentageButton: UIButton!
    @IBOutlet weak var increaseHiTipPercentageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")

        let userDefaults = UserDefaults.standard
        lowTipPercentageLabel.text = String(format: "%d%%", userDefaults.object(forKey: "lowTip") as? Int ?? tipPercentagesConstant.low)
        medTipPercentageLabel.text = String(format: "%d%%", userDefaults.object(forKey: "medTip") as? Int ?? tipPercentagesConstant.med)
        hiTipPercentageLabel.text = String(format: "%d%%", userDefaults.object(forKey: "hiTip") as? Int ?? tipPercentagesConstant.hi)
        userDefaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewwilldisappear")
        let userDefaults = UserDefaults.standard
        userDefaults.set(percentLabelToInt(label: lowTipPercentageLabel), forKey: "lowTip")
        userDefaults.set(percentLabelToInt(label: medTipPercentageLabel), forKey: "medTip")
        userDefaults.set(percentLabelToInt(label: hiTipPercentageLabel), forKey: "hiTip")
        userDefaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func percentLabelToInt(label: UILabel) -> Int {
        var percentLabelText = label.text!
        percentLabelText.remove(at: percentLabelText.index(before: percentLabelText.endIndex))
        return Int(percentLabelText)!
    }
    
    func updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment) {
        var tipPercentageLabel = lowTipPercentageLabel!
        var adjustTipPercentageButton = decreaseLowTipPercentageButton!
        var decrease = true
        
        switch tipPercentageAdjustment {
            case .decreaseLowTipPercentage:
                tipPercentageLabel = lowTipPercentageLabel;
                adjustTipPercentageButton = decreaseLowTipPercentageButton;
                decrease = true;
            case .decreaseMedTipPercentage:
                tipPercentageLabel = medTipPercentageLabel;
                adjustTipPercentageButton = decreaseMedTipPercentageButton;
                decrease = true;
            case .decreaseHiTipPercentage:
                tipPercentageLabel = hiTipPercentageLabel;
                adjustTipPercentageButton = decreaseHiTipPercentageButton;
                decrease = true;
            case .increaseLowTipPercentage:
                tipPercentageLabel = lowTipPercentageLabel;
                adjustTipPercentageButton = increaseLowTipPercentageButton;
                decrease = false;
            case .increaseMedTipPercentage:
                tipPercentageLabel = medTipPercentageLabel;
                adjustTipPercentageButton = increaseMedTipPercentageButton;
                decrease = false;
            case .increaseHiTipPercentage:
                tipPercentageLabel = hiTipPercentageLabel;
                adjustTipPercentageButton = increaseHiTipPercentageButton;
                decrease = false;
        }
        
        var tipPercentage = tipPercentageLabel.text!
        tipPercentage.remove(at: tipPercentage.index(before: tipPercentage.endIndex))
        
        // Void the button when tip will below 0 or above 100
        if (Int(tipPercentage)! <= 1 || Int(tipPercentage)! >= 100) {
            adjustTipPercentageButton.isEnabled = false
        }
        
        if (decrease) {
            tipPercentageLabel.text = String(format: "%d%%", Int(tipPercentage)! > 0 ? Int(tipPercentage)! - 1 : 0)
        } else {
            tipPercentageLabel.text = String(format: "%d%%", Int(tipPercentage)! < 100 ? Int(tipPercentage)! + 1 : 100)
        }
    }
    
    @IBAction func decreaseLowTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.decreaseLowTipPercentage)
    }

    @IBAction func increaseLowTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.increaseLowTipPercentage)
    }
    
    @IBAction func decreaseMedTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.decreaseMedTipPercentage)
    }
    
    @IBAction func increaseMedTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.increaseMedTipPercentage)
    }
    
    @IBAction func decreaseHiTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.decreaseHiTipPercentage)
    }
    
    @IBAction func increaseHiTipPercentage(_ sender: AnyObject) {
        updateTipLabel(tipPercentageAdjustment: tipPercentageAdjustment.increaseHiTipPercentage)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
