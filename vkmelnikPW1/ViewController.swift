//
//  ViewController.swift
//  vkmelnikPW1
//
//  Created by Всеволод on 14.09.2021.
//

import UIKit

extension UIColor {
    
    // Get substring.
    static func subString(str: String, startIndex: Int, endIndex: Int) -> String {
        let start = str.index(str.startIndex, offsetBy: startIndex)
        let end = str.index(str.startIndex, offsetBy: endIndex)
        let range = start..<end
        return String(str[range])
    }
    
    convenience init?(hex: String) {
        let str = hex.filter { $0 != "#" }
        if (str.count != 6) {
            return nil
        }
        
        let redHex = Self.subString(str: str, startIndex: 0, endIndex: 2)
        let greenHex = Self.subString(str: str, startIndex: 2, endIndex: 4)
        let blueHex = Self.subString(str: str, startIndex: 4, endIndex: 6)
        
        if let red = Int(redHex, radix: 16),
           let green = Int(greenHex, radix: 16),
           let blue = Int(blueHex, radix: 16) {
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var views: [UIView]!
    
    var orderedConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    // Assign views new unique colors.
    @IBAction func changeColorButtonPressed(_ sender: Any) {
        var set = Set<UIColor>()
        while set.count < views.count {
            set.insert(
                UIColor(
                    hex: String(format:"%06X", Int.random(in: 0..<(1<<24)))
                )!
            )
        }
        
        let button = sender as? UIButton
        button?.isEnabled = false
        UIView.animate(withDuration: 2, animations: {
            for view in self.views {
                view.backgroundColor = set.popFirst()
            }
        }) { completion in
            button?.isEnabled = true
        }
    }
    
    // Constraints for an ordered view.
    func getOrderedConstraints(view: UIView, index: Int) -> [NSLayoutConstraint] {
        let superview = view.superview
        let verticalConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superview, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -80 + 80 * CGFloat(index / 3))
        let horizontalConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superview, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: -80 + 80 * CGFloat((index % 3)))
        let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        var constraints = [NSLayoutConstraint]()
        constraints.append(verticalConstraint)
        constraints.append(horizontalConstraint)
        constraints.append(widthConstraint)
        constraints.append(heightConstraint)
        return constraints
    }
    
    // Order views on the screen.
    @IBAction func orderButtonPressed(_ sender: Any) {
        let button = sender as? UIButton
        button?.isEnabled = false
        
        UIView.animate(withDuration: 2, animations: {
            NSLayoutConstraint.deactivate(self.view.constraints)
            NSLayoutConstraint.activate(self.orderedConstraints)
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set rounded corners to views and generate ordered constraints.
        var i : Int = 0
        for view in views {
            view.layer.cornerRadius = 10
            orderedConstraints.append(contentsOf: self.getOrderedConstraints(view: view, index: i))
            i += 1
        }
    }


}

