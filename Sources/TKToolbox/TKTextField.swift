//
//  TKTextField.swift
//  TKToolbox
//
//  Created by Thorsten Klusemann on 08.09.17.
//

import UIKit

public class TKTextField: UITextField {

  internal var placeholderLabel: UILabel = UILabel()
  internal var eventHandlers: [TKTextFieldEventHandler] = []

  public var textFieldInsets: CGPoint = CGPoint(x: 8, y: 8)

  public var tkBorderStyle: TKTextFieldBorderStyle? {
    didSet {
      tkBorderStyle?.configure(self)
    }
  }

  public var tkPlaceholderStyle: TKTextFieldPlaceholderStyle? {
    didSet {
      tkPlaceholderStyle?.configure(self)
    }
  }

  // MARK: - Initialization
  //

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    self.borderStyle = .none
  }
  
  // MARK: - Drawing of the component
  //

  public override func draw(_ rect: CGRect) {
    tkBorderStyle?.drawBorder(rect)
    tkPlaceholderStyle?.drawPlaceholder(rect)
  }
  
  public override func drawPlaceholder(in rect: CGRect) {
    // Don't draw default placeholder
  }

  // MARK: - Adjust editing rectangles
  //

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.insetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
  }
  
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.insetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
  }
  
  // MARK: - Setup editing notifications
  //
  
  public override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview != nil {
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
    } else {
      NotificationCenter.default.removeObserver(self)
    }
  }
  
  @objc internal func textFieldDidBeginEditing() {
    eventHandlers.forEach { $0.didBeginEditing(text: text) }
  }

  @objc internal func textFieldDidChange() {
    eventHandlers.forEach { $0.didChange(text: text) }
  }

  @objc internal func textFieldDidEndEditing() {
    eventHandlers.forEach { $0.didEndEditing(text: text) }
  }
  
  // MARK: - Animations
  //
  
  internal func register(eventHandler: TKTextFieldEventHandler) {
    print("Registering animation style \(eventHandler.id)")
    eventHandlers.append(eventHandler)
  }
  
  internal func unregister(eventHandler: TKTextFieldEventHandler) {
    print("Unregistering animation style \(eventHandler.id)")
    let index = eventHandlers.index { style in
      return style.id == eventHandler.id
    }
    if let index = index {
      eventHandlers.remove(at: index)
    }
  }
}


