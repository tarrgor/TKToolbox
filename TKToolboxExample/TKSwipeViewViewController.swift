//
//  TKSwipeViewViewController.swift
//  TKToolboxExample
//
//  Created by Thorsten Klusemann on 01.11.17.
//

import UIKit
import TKToolbox

class TKSwipeViewViewController: UIViewController {
  
  var container: TKSwipeContainerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    container = TKSwipeContainerView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.delegate = self
    
    let sv1 = TKSwipeView.init()
    sv1.contentView.backgroundColor = .gray
    sv1.isSwipeable = false
    container.push(sv1)
    
    let sv2 = TKSwipeView.init()
    sv2.contentView.backgroundColor = .orange
    sv2.isCastingShadows = true
    container.push(sv2)
    
    self.view.addSubview(container)
    
    container.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
  }
  
}

extension TKSwipeViewViewController: TKSwipeViewDelegate {
  func swipeView(_ view: TKSwipeView, didLeaveHotRegion region: TKSwipeView.HotRegion) {
    print(#function)
  }
  
  func swipeView(_ view: TKSwipeView, didReachHotRegion region: TKSwipeView.HotRegion) {
    print(#function)
  }
  
  func swipeView(_ view: TKSwipeView, didConfirmHotRegion region: TKSwipeView.HotRegion) {
    container.pop()
  }
}


