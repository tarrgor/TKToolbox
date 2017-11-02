//
//  TKSwipeView.swift
//  SpotiePlaygroundWrapper
//
//  Created by Thorsten Klusemann on 09.10.17.
//  Copyright © 2017 Thorsten Klusemann. All rights reserved.
//

import UIKit

public protocol TKSwipeViewDelegate: class {
  
  func swipeView(_ view: TKSwipeView, didReachHotRegion region: TKSwipeView.HotRegion)
  func swipeView(_ view: TKSwipeView, didLeaveHotRegion region: TKSwipeView.HotRegion)
  func swipeView(_ view: TKSwipeView, didConfirmHotRegion region: TKSwipeView.HotRegion)

}

public final class TKSwipeView: UIView {

  public enum HotRegion {
    case left
    case right
  }

  // Public properties
  //
  
  /// The delegate to call when defined events occure like the view is reaching
  /// the 'hot region' in which an action is about to be executed when the user
  /// releases the view within that region.
  public weak var delegate: TKSwipeViewDelegate?
  
  /// Determines if the TKSwipeView should cast a shadow beneath itself
  public var isCastingShadows: Bool = false {
    didSet {
      setShadowsEnabled(isCastingShadows, shadowOffset)
    }
  }
  
  /// If isCastingShadows is enabled, shadowOffset defines the size of the shadow as an offset.
  /// Defaults to CGSize(4, 4)
  public var shadowOffset: CGSize = .init(width: 4, height: 4) {
    didSet {
      setShadowsEnabled(isCastingShadows, shadowOffset)
    }
  }
  
  /// Returns the current hot region of the TKSwipeView. Returns nil if it is not in
  /// a hot region
  public var hotRegion: HotRegion? {
    return currentHotRegion
  }
  
  /// Returns the content view which should be used to place your own subviews in it
  public var contentView: UIView {
    return _contentView
  }
  
  // Internal properties
  //
  fileprivate var _contentView: UIView!

  var panGestureRecognizer: UIPanGestureRecognizer!
  var isActive: Bool = true {
    didSet {
      panGestureRecognizer.isEnabled = isActive
    }
  }
  
  var startLocation: CGPoint = CGPoint.zero

  var currentHotRegion: HotRegion? {
    didSet {
      if oldValue != nil && currentHotRegion == nil {
        self.delegate?.swipeView(self, didLeaveHotRegion: oldValue!)
      } else if oldValue == nil && currentHotRegion != nil {
        self.delegate?.swipeView(self, didReachHotRegion: currentHotRegion!)
      }
    }
  }
  
  public convenience init(active: Bool = true) {
    self.init(frame: CGRect.zero)
    self.isActive = active
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
}

extension TKSwipeView {
  
  public override func updateConstraints() {
    setupConstraints()
    super.updateConstraints()
  }
  
}

extension TKSwipeView {
  
  // Private methods
  //
  fileprivate func setup() {
    _contentView = UIView(frame: self.bounds)
    _contentView.backgroundColor = .green
    addSubview(_contentView)
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)))
    self.addGestureRecognizer(panGestureRecognizer)
  }
  
  fileprivate func setupConstraints() {
    _contentView.translatesAutoresizingMaskIntoConstraints = false
    _contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    _contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    _contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    _contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }

  fileprivate func setShadowsEnabled(_ enabled: Bool, _ offset: CGSize) {
    self.layer.shadowColor = UIColor.darkGray.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = offset
    self.layer.shadowRadius = 2
    self.layer.masksToBounds = !enabled
  }
  
  @objc fileprivate func panned(recognizer: UIGestureRecognizer) {
    guard let superview = self.superview else { return }
    
    let location = recognizer.location(in: superview)
    
    switch recognizer.state {
    case .began:
      startLocation = location
    case .changed:
      let angle = calculateRotationAngle(location: location, startLocation: startLocation)
      if angle < -0.25 {
        self.currentHotRegion = .left
      } else if angle > 0.25 {
        self.currentHotRegion = .right
      } else {
        self.currentHotRegion = nil
      }
      rotateBy(angle: angle)
    case .cancelled:
      animateBackToDefaultPosition()
    case .ended:
      if currentHotRegion == nil {
        animateBackToDefaultPosition()
      } else {
        self.delegate?.swipeView(self, didConfirmHotRegion: currentHotRegion!)
      }
    default:
      break
    }
  }

  fileprivate func animateBackToDefaultPosition() {
    UIView.animate(withDuration: 0.3, animations: {
      let transform = CGAffineTransform(rotationAngle: CGFloat(0.0))
      self.layer.setAffineTransform(transform)
      self.layer.position.x = self.bounds.midX
    })
  }
  
  fileprivate func calculateRotationAngle(location: CGPoint, startLocation: CGPoint) -> CGFloat {
    let diffX = self.bounds.midX - (startLocation.x - location.x)
    let normalizedDiffX = min(max(diffX, 0), self.bounds.maxX)
    return ((-self.bounds.midX + normalizedDiffX) / self.bounds.midX) * 0.3
  }
  
  fileprivate func rotateBy(angle: CGFloat) {
    let rotate = CGAffineTransform(rotationAngle: CGFloat(angle))
    layer.setAffineTransform(rotate)
    layer.position.x = self.bounds.midX + (angle * self.bounds.midX) * 2.5
  }
  
}

