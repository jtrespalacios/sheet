//
//  MenuViewController.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/19/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
  func save()
  func clear()
  func reload()
}

class MenuViewController: UIViewController {
  weak var delegate: MenuViewControllerDelegate?
  var sheetHasChanges = false
  private enum Actions: Int {
    case save = 1
    case clear = 2
    case reload = 3
  }
  
  override func loadView() {
    let view = UIView(frame: .zero)
    var tag = 1
    let buttons: [UIButton] = ["Save", "Clear", "Reload"].map {
      let button = UIButton(type: .System)
      button.setTitle($0, forState: .Normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(MenuViewController.handleButtonPress), forControlEvents: .TouchUpInside)
      button.sizeToFit()
      button.tag = tag
      tag += 1
      return button
    }
    let stackView = UIStackView(arrangedSubviews: buttons)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 20
    stackView.alignment = .Fill
    stackView.axis = .Vertical
    view.addSubview(stackView)
    stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    stackView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
    view.leftAnchor.constraintGreaterThanOrEqualToAnchor(stackView.leftAnchor, constant: 20).active = true
    stackView.rightAnchor.constraintGreaterThanOrEqualToAnchor(view.rightAnchor, constant: 20).active = true

    view.backgroundColor = UIColor.lightGrayColor()
    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Menu"
  }

  func handleButtonPress(sender: UIButton) {
    guard let selectedTag = Actions(rawValue: sender.tag) else {
      return
    }
    switch selectedTag {
    case .save:
      self.delegate?.save()
    case .clear:
      let alert = UIAlertController(title: "Are you sure?",
                                    message: "Clearing the table will remove all data",
                                    preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Destructive) { _ in
        self.delegate?.clear()
      })
      alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    case .reload:
      if sheetHasChanges {
        self.showDestructiveReloadAlert()
      } else {
        self.showInvalidReloadAlert()
      }
    }
  }

  private func showDestructiveReloadAlert() {
    let alert = UIAlertController(title: "Are you sure?",
                                  message: "Reloading will remove any changes since your last save.",
                                  preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Destructive) { _ in
      self.delegate?.reload()
      })
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }

  private func showInvalidReloadAlert() {
    let alert = UIAlertController(title: "Nothing to reload",
                                  message: "No changes have been made since last save.",
                                  preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
