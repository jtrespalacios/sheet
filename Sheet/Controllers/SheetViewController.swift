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

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    toolbar.items = [spaceItem, undoButton]
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
    let formatStrings = [ "H:|[tb]|", "H:|[cv]|", "V:|[cv][tb]|" ]
    self.view.addConstraints(visualFormatStrings: formatStrings, options: [], metrics: nil, views: views)
    self.collectionView.registerClass(SheetCell.self, forCellWithReuseIdentifier: SheetCell.reuseIdentifier)
    self.collectionView.dataSource = self
  }

  func undo() { }
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
    cell.textLabel.text = "Hello"
    return cell
  }
}