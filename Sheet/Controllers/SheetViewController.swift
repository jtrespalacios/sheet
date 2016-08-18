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
  private weak var editView: UIView?

  override func loadView() {
    let view = UIView(frame: .zero)
    let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: #selector(SheetViewController.undo))
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(SheetViewController.edit))
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let toolbar = UIToolbar(frame: .zero)
    let layout = SheetLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    toolbar.items = [editButton, spaceItem, undoButton]
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toolbar)
    view.addSubview(collectionView)
    view.backgroundColor = UIColor.whiteColor()

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
    let formatStrings = [ "H:|[tb]|", "H:|[cv]|", "V:[tlg][cv][tb]|" ]
    self.view.addConstraints(visualFormatStrings: formatStrings, options: [], metrics: nil, views: views)
    self.collectionView.registerClass(SheetCell.self, forCellWithReuseIdentifier: SheetCell.reuseIdentifier)
    self.collectionView.dataSource = self
  }

  func undo() { }
  func edit() {
    guard self.editView == nil else {
      return
    }
    let editView = EditView(title: "Edit Cell")
    editView.hidden = true
    self.view.addSubview(editView)
    editView.widthAnchor.constraintEqualToConstant(275).active = true
    editView.heightAnchor.constraintEqualToConstant(160).active = true
    self.view.centerXAnchor.constraintEqualToAnchor(editView.centerXAnchor).active = true
    self.view.centerYAnchor.constraintEqualToAnchor(editView.centerYAnchor).active = true
    editView.setNeedsLayout()
    editView.layoutIfNeeded()
    editView.delegate = self
    self.editView = editView
    UIView.transitionWithView(self.view,
                              duration: 0.2,
                              options: [.TransitionCrossDissolve, .CurveEaseOut],
                              animations: { editView.hidden = false },
                              completion: { _ in editView.becomeFirstResponder() })
  }
}

extension SheetViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 5
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SheetCell.reuseIdentifier, forIndexPath: indexPath) as? SheetCell else {
      fatalError("Did not get the correct kind of cell")
    }
    return cell
  }
}

extension SheetViewController: EditViewDelegate {
  func completedEditing(inView view: EditView, resolution: EditView.Resolution) {
    let res: String
    switch resolution {
    case .commit(.Some(let value)):
      res = "commit value \(value)"
    case .commit(nil):
      res = "clear value at location"
    case .cancel:
      res = "canceled"
    default:
      res = "the imposible happened"
    }
    print("Edit view completed editing with resolution \(res)")
    UIView.transitionWithView(self.view,
                              duration: 0.2,
                              options: [.CurveEaseIn, .TransitionCrossDissolve],
                              animations: { view.removeFromSuperview() },
                              completion: nil)
  }
}