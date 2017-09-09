//
//  ViewController.swift
//  TKToolboxExample
//
//  Created by Thorsten Klusemann on 10.09.17.
//

import UIKit
import TKToolbox

class ViewController: UIViewController {

  @IBOutlet weak var textField: TKTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    textField.font = UIFont(name: "HelveticaNeue-Regular", size: 24)
    textField.textFieldInsets = CGPoint(x: 8, y: 14)
    
    let borderStyle = TKUnderlineBorderStyle()
    textField.tkBorderStyle = borderStyle
    let placeholderStyle = TKPlaceholderStyle()
    placeholderStyle.alignment = .center
    placeholderStyle.animationStyle = TKFadeOutAnimationStyle()
    textField.tkPlaceholderStyle = placeholderStyle
  }

}

