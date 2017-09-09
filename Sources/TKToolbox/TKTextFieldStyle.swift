//
//  TKTextFieldStyle.swift
//  TKToolbox
//
//  Created by Thorsten Klusemann on 09.09.17.
//

import UIKit

public protocol TKTextFieldStyle {
  func configure(_ textField: TKTextField)
}

public protocol TKAnimationStyle {
  func configure(_ view: UIView)
}

public protocol TKTextFieldBorderStyle: TKTextFieldStyle {
  func drawBorder(_ rect: CGRect)
}

public protocol TKTextFieldPlaceholderStyle: TKTextFieldStyle {
  func drawPlaceholder(_ rect: CGRect)
}

public enum TKTextFieldAnimationState {
  case notExecuted
  case executed
}

public protocol TKTextFieldAnimationStyle: TKAnimationStyle {
  var duration: TimeInterval { get set }
  var state: TKTextFieldAnimationState { get }
  
  func animate()
  func animateReverse()
}

internal protocol TKTextFieldEventHandler {
  var id: UUID { get }

  func didBeginEditing(text: String?)
  func didChange(text: String?)
  func didEndEditing(text: String?)
}
