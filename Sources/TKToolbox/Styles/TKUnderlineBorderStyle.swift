//
//  TKUnderlineBorderStyle.swift
//  TKToolbox
//
//  Created by Thorsten Klusemann on 09.09.17.
//

import UIKit

public class TKUnderlineBorderStyle: TKTextFieldBorderStyle {
  
  private var _textField: TKTextField?
  
  public var lineWidth: CGFloat = 2.0
  
  public init() {
  }
  
  public func configure(_ textField: TKTextField) {
    self._textField = textField
  }
  
  public func drawBorder(_ rect: CGRect) {
    guard let textField = _textField else { return }
    let layer = createLineLayer(rect: rect, lineWidth: lineWidth)
    textField.layer.addSublayer(layer)
  }
  
  private func createLineLayer(rect: CGRect, lineWidth: CGFloat) -> CALayer {
    let layer = CALayer()
    layer.frame = CGRect(x: rect.origin.x, y: rect.size.height - 2, width: rect.size.width, height: lineWidth)
    layer.backgroundColor = UIColor.darkGray.cgColor
    return layer
  }
}

