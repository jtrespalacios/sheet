//
//  ViewController.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/16/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

protocol UndoManager {
  func logChange(atCoordinate coordinate: Coordinate, value: String?)
  func lastValue(forCoordinate coordinate: Coordinate) -> String?
  func historyAvailable(forCoordinate coordinate: Coordinate) -> Bool
}

class SheetViewController: UIViewController {
  weak var toolbar: UIToolbar!
  weak var undoButton: UIBarButtonItem!
  weak var collectionView: UICollectionView!
  private var selectedIndexPath: Coordinate?

  override func loadView() {
    let view = UIView(frame: .zero)
    let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: #selector(SheetViewController.undo))
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let toolbar = UIToolbar(frame: .zero)
    let layout = SheetLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    undoButton.enabled = false
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
    let formatStrings = [ "H:|[tb]|", "H:|[cv]|", "V:[tlg][cv][tb]|" ]
    self.view.addConstraints(visualFormatStrings: formatStrings, options: [], metrics: nil, views: views)
    self.collectionView.registerClass(SheetCell.self, forCellWithReuseIdentifier: SheetCell.reuseIdentifier)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }

  func undo() { }
}

extension SheetViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let sip = self.selectedIndexPath where sip.row == indexPath.section && sip.column == indexPath.item {
      collectionView.deselectItemAtIndexPath(indexPath, animated: true)
      self.selectedIndexPath = nil
      return
    }
    self.selectedIndexPath = Coordinate(indexPath: indexPath)
    print("Selected \(indexPath)")
  }
}

extension SheetViewController: UICollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 12
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SheetCell.reuseIdentifier, forIndexPath: indexPath) as? SheetCell else {
      fatalError("Did not get the correct kind of cell")
    }
    return cell
  }
}
/* Rework into EditCellDelegate
extension SheetViewController: EditViewDelegate {
  func completedEditing(inView view: EditView, resolution: EditView.Resolution) {
    let res: String
    switch resolution {
    case .commit(.Some(let value)):
      res = "commit value \(value)"
    case .commit(.None):
      res = "clear value at location"
    case .cancel:
      res = "canceled"
    }
    print("Edit view completed editing with resolution \(res)")
    UIView.transitionWithView(self.view,
                              duration: 0.2,
                              options: [.CurveEaseIn, .TransitionCrossDissolve],
                              animations: { view.removeFromSuperview() },
                              completion: nil)
  }
}
 */