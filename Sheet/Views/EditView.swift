//
//  EditView.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

protocol SheetEditCellDelegate: class {
  func completedEditing(inView view: SheetEditCell, resolution: SheetEditCell.Resolution)
}

class SheetEditCell: SpreadSheetCell {
  static let reuseIdentifier = "co.j3p.Sheet.SheetEditCell"

  enum Resolution {
    case commit(String?)
    case cancel
  }

  private weak var input: UITextField!
  weak var delegate: SheetEditCellDelegate?

  override init(frame: CGRect) {
    let input = UITextField(frame: .zero)
    input.borderStyle = .None
    input.keyboardType = .ASCIICapable
    input.autocapitalizationType = .None
    input.returnKeyType = .Done
    self.input = input
    super.init(frame: frame)
    self.contentView.addSubview(input)
    self.backgroundColor = .whiteColor()
    let views = ["in": input]
    input.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat("H:|-[in]-|", options: [], metrics: nil, views: views)
    )
    let view = UIView(frame: self.bounds)
    input.centerXAnchor.constraintEqualToAnchor(self.contentView.centerXAnchor).active = true
    input.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
    view.layer.borderColor = UIColor.orangeColor().CGColor
    view.layer.borderWidth = 1
    self.backgroundView = view
    input.delegate = self
  }

  override func canBecomeFirstResponder() -> Bool {
    return self.input.becomeFirstResponder()
  }

  override func becomeFirstResponder() -> Bool {
    return self.input.becomeFirstResponder()
  }

  override func resignFirstResponder() -> Bool {
    return self.input.resignFirstResponder()
  }

  override func canResignFirstResponder() -> Bool {
    return self.input.canResignFirstResponder()
  }

  @objc func resolveEdit() {
    func getInputValue() -> String? {
      let trimedInput = self.input.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
      return trimedInput?.characters.count > 0 ? trimedInput! : nil
    }
    let resolution: Resolution = .commit(getInputValue())
    self.delegate?.completedEditing(inView: self, resolution: resolution)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setText(value: String?) {
    self.input.text = value
  }
}

extension SheetEditCell: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.resolveEdit()
    self.resignFirstResponder()
    return true
  }
}