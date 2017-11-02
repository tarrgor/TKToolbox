//
//  TKSwipeContainerView.swift
//  TKSwipeView
//
//  Created by Thorsten Klusemann on 09.10.17.
//

import UIKit

public final class TKSwipeContainerView: UIView {

  public typealias Animation = (TKSwipeView) -> (Void)
  
  var stack: [TKSwipeView] = []
  
  public weak var delegate: TKSwipeViewDelegate?
  
  // Initialization
  //
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  fileprivate func setup() {
    self.backgroundColor = UIColor.white
  }
}

public extension TKSwipeContainerView {

  // Public properties
  //
  
  /// Returns true if there is currently no TKSwipeView on the stack
  ///
  var isEmpty: Bool {
    return stack.count == 0
  }
  
}

public extension TKSwipeContainerView {
  
  // Public methods
  //
  
  /// Pushes a TKSwipeView on top of the stack
  ///
  public func push(_ swipeView: TKSwipeView) {
    // remove existing constraints from swipeView and remove it
    // from superview (if exists)
    swipeView.removeFromSuperview()
    swipeView.removeConstraints(swipeView.constraints)

    // add the view as a subview to the container
    addSubview(swipeView)
    
    // set new constraints to container view
    setupConstraints(forSwipeView: swipeView)
    
    // deactivate previous swipe view (gesture recognition) and remove delegate
    if let prevSwipeView = stack.last {
      prevSwipeView.isActive = false
      prevSwipeView.delegate = nil
    }
    
    // set delegate of the new swipeView to the delegate of the container
    swipeView.delegate = delegate
    swipeView.isActive = true
    
    // put it on the stack
    stack.append(swipeView)
  }
  
  /// Remove the top TKSwipeView from the stack
  ///
  public func pop(withAnimation animation: Animation? = nil) {
    guard stack.count > 0 else { return }
    
    // remove last element from stack and deactivate it
    let removedSwipeView = stack.removeLast()
    removedSwipeView.delegate = nil
    removedSwipeView.isActive = false
    
    // activate next swipe view
    if let newSwipeView = stack.last {
      newSwipeView.isActive = true
      newSwipeView.delegate = delegate
    }
    
    // animate out and remove from superview
    UIView.animate(withDuration: 0.3, animations: {
      if animation != nil {
        animation?(removedSwipeView)
      } else {
        self.performDefaultAnimation(using: removedSwipeView)
      }
    }, completion: { _ in
      removedSwipeView.removeFromSuperview()
    })
  }
  
}

fileprivate extension TKSwipeContainerView {
  
  func setupConstraints(forSwipeView swipeView: TKSwipeView) {
    swipeView.translatesAutoresizingMaskIntoConstraints = false
    swipeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    swipeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    swipeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    swipeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  func performDefaultAnimation(using view: TKSwipeView) {
    var direction: CGFloat = 0
    switch view.hotRegion {
    case .some(.left):
      direction = -1
    case .some(.right):
      direction = 1
    default:
      direction = 0
    }
    
    view.frame.origin.x += (200 * direction)
    view.alpha = 0
  }
  
}
