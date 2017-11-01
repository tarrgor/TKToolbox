//
//  TKPlaceholderStyle.swift
//  TKToolbox
//
//  Created by Thorsten Klusemann on 09.09.17.
//

import UIKit

public class TKPlaceholderStyle: TKTextFieldPlaceholderStyle {

  private var _textField: TKTextField?
  
  public let id: UUID = UUID()

  public var insets: CGPoint = CGPoint(x: 8, y: 8)
  public var alignment: NSTextAlignment = .left
  public var color: UIColor = .black
  public var alpha: CGFloat = 0.5
  
  public var animationStyle: TKTextFieldAnimationStyle?
  
  public init() {
    
  }
  
  public func configure(_ textField: TKTextField) {
    self._textField = textField
    self._textField?.addSubview(textField.placeholderLabel)
    textField.placeholderLabel.textAlignment = alignment
    textField.placeholderLabel.textColor = color.withAlphaComponent(alpha)
    textField.placeholderLabel.font = textField.font
    if let animationStyle = animationStyle {
      animationStyle.configure(textField.placeholderLabel)
      textField.register(eventHandler: self)
    }
  }

  public func drawPlaceholder(_ rect: CGRect) {
    updatePlaceholder(rect)
  }
  
  public func updatePlaceholder(_ rect: CGRect) {
    guard let textField = _textField else { return }
    _textField?.placeholderLabel.frame = textField.bounds.insetBy(dx: insets.x, dy: insets.y)
    _textField?.placeholderLabel.text = textField.placeholder
  }
}

extension TKPlaceholderStyle: TKTextFieldEventHandler {
  
  func didBeginEditing(text: String?) { }
  
  func didChange(text: String?) {
    if let text = text, let animationStyle = animationStyle {
      if text.count > 0 && animationStyle.state == .notExecuted {
        animationStyle.animate()
      } else if text.count == 0 && animationStyle.state == .executed {
        animationStyle.animateReverse()
      }
    }
  }
  
  func didEndEditing(text: String?) { }
  
}
