//
//  SegmentedControl.swift
//  tipster
//
//  Created by Sophia on 3/10/17.
//
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor(red:0.35, green:0.58, blue:0.73, alpha:1.0) {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    var items: [String] = ["😑", "🙂", "😘"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = UIColor.white
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            
            let xPos = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPos, y: 0, width: labelWidth, height: labelHeight)
        }
        
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        
        for(index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func setupView() {
        layer.cornerRadius = frame.height / 2;
        layer.borderColor = UIColor(white:1.5, alpha:0.5).cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0.0, height: 0.0))
            label.text = items[index - 1];
            label.textAlignment = .center
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    func displayNewSelectedIndex() {
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            self.thumbView.frame = label.frame
        }, completion: nil)
        
    }
}
