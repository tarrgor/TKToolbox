//
//  TKFadingAnimationStyle.swift
//  TKToolbox
//
//  Created by Thorsten Klusemann on 09.09.17.
//

import UIKit

public class TKFadeOutAnimationStyle: TKTextFieldAnimationStyle {

  private var _viewToAnimate: UIView?
  private var _state: TKTextFieldAnimationState = .notExecuted
  
  public let id: UUID = UUID()
  public var duration: TimeInterval = 0.3
  
  public var state: TKTextFieldAnimationState {
    return _state
  }
  
  public init() {
    
  }
  
  public func configure(_ view: UIView) {
    self._viewToAnimate = view
  }
  
  public func animate() {
    UIView.animate(withDuration: duration) {
      self._viewToAnimate?.alpha = 0
      self._state = .executed
    }
  }
  
  public func animateReverse() {
    UIView.animate(withDuration: duration) {
      self._viewToAnimate?.alpha = 1
      self._state = .notExecuted
    }
  }
  
}

