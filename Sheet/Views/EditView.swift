//
//  EditView.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

protocol EditViewDelegate: class {
  func completedEditing(inView view: EditView, resolution: EditView.Resolution)
}

class EditView: UIView {
  enum Resolution {
    case commit(String?)
    case cancel
  }

  enum ResolutionButton: Int {
    case ok
    case cancel
  }

  private weak var input: UITextField!
  private weak var okButton: UIButton!
  weak var delegate: EditViewDelegate?

  init(title: String, value: String? = nil) {
    let input = UITextField(frame: .zero)
    input.placeholder = "Enter a value"
    input.borderStyle = .RoundedRect
    let okButton = UIButton(type: .System)
    okButton.tag = ResolutionButton.ok.rawValue
    okButton.setTitle("ok", forState: .Normal)
    let cancelButton = UIButton(type: .System)
    cancelButton.tag = ResolutionButton.cancel.rawValue
    cancelButton.setTitle("cancel", forState: .Normal)
    let titleLabel = UILabel(frame: .zero)
    titleLabel.text = title
    input.text = value
    input.keyboardType = .ASCIICapable
    input.autocapitalizationType = .None
    input.returnKeyType = .Done
    self.input = input
    self.okButton = okButton
    super.init(frame: .zero)

    self.translatesAutoresizingMaskIntoConstraints = false
    [okButton, cancelButton, input, titleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
    okButton.sizeToFit()
    cancelButton.sizeToFit()
    titleLabel.sizeToFit()
    titleLabel.textAlignment = .Center
    let views = [
      "in": input,
      "ok": okButton,
      "cn": cancelButton,
      "lb": titleLabel
    ]
    let formats = ["H:|[lb]|", "H:|-[in]-|", "H:|-[cn]-[ok(==cn)]-|"]
    self.addConstraints(visualFormatStrings: formats, options: [.AlignAllCenterY], metrics: nil, views: views)
    self.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat("V:|-[lb]-12-[in]-[ok]-|", options: [], metrics: nil, views: views)
    )

    okButton.addTarget(self, action: #selector(EditView.resolveEdit), forControlEvents: .TouchUpInside)
    cancelButton.addTarget(self, action: #selector(EditView.resolveEdit), forControlEvents: .TouchUpInside)

    self.backgroundColor = .whiteColor()
    self.layer.cornerRadius = 20
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

  @objc func resolveEdit(sender: UIButton) {
    let button = ResolutionButton(rawValue: sender.tag)!
    let resolution: Resolution

    func getInputValue() -> String? {
      let trimedInput = self.input.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
      return trimedInput?.characters.count > 0 ? trimedInput! : nil
    }

    switch button {
    case .ok:
      resolution = .commit(getInputValue())
    case .cancel:
      resolution = .cancel
    }

    self.delegate?.completedEditing(inView: self, resolution: resolution)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension EditView: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.resolveEdit(self.okButton)
    return true
  }
}