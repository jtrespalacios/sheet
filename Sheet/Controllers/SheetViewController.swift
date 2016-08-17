//
//  ViewController.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/16/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

class SheetViewController: UIViewController {
  weak var toolbar: UIToolbar!
  weak var undoButton: UIBarButtonItem!
  weak var collectionView: UICollectionView!

  override func loadView() {
    let view = UIView(frame: .zero)
    let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: #selector(SheetViewController.undo))
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let toolbar = UIToolbar(frame: .zero)
    let layout = SheetLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    view.backgroundColor = UIColor.whiteColor()
    toolbar.items = [spaceItem, undoButton]
    view.addSubview(toolbar)
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    self.view = view
    self.undoButton = undoButton
    self.collectionView = collectionView
    self.toolbar = toolbar
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Sheet"
    let views = [
      "cv": self.collectionView,
      "tb": self.toolbar,
      "tlg": self.topLayoutGuide as AnyObject
    ]
    let formatStrings = [
      "H:|[tb]|", "H:|[cv]|", "V:|[cv][tb]|"
    ]
    self.view.addConstraints(formatStrings, options: [], metrics: nil, views: views)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func undo() {

  }
}

extension UIView {
  public func addConstraints(visualFormatStrings: [String], options opts: NSLayoutFormatOptions, metrics: [String: AnyObject]?, views: [String: AnyObject]) {
    for s in visualFormatStrings {
      self.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(s, options: opts, metrics: metrics, views: views)
      )
    }
  }
}