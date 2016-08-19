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
  private var selectedLocation: Coordinate?

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
    collectionView.bounces = false
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
    self.collectionView.registerClass(SheetEditCell.self, forCellWithReuseIdentifier: SheetEditCell.reuseIdentifier)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }

  func undo() { }
}

extension SheetViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var indexPathsToReload = [indexPath]
    if let sip = self.selectedLocation {
      if  sip.row == indexPath.section && sip.column == indexPath.item {
        self.selectedLocation = nil
      } else {
        indexPathsToReload.append(NSIndexPath(coordinate: sip))
        self.selectedLocation = Coordinate(indexPath: indexPath)
      }
    } else {
      self.selectedLocation = Coordinate(indexPath: indexPath)
    }

    self.collectionView.reloadItemsAtIndexPaths(indexPathsToReload)
  }

  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    self.collectionView.reloadItemsAtIndexPaths([indexPath])
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
    let coordinate = Coordinate(indexPath: indexPath)
    let reuseId: String
    if coordinate == self.selectedLocation {
      reuseId = SheetEditCell.reuseIdentifier
    }
    else {
      reuseId = SheetCell.reuseIdentifier
    }

    guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as? SpreadSheetCell else {
      fatalError("Did not get the correct kind of cell")
    }

    if let editCell =  cell as? SheetEditCell {
      editCell.delegate = self
      dispatch_async(dispatch_get_main_queue()) {
        editCell.becomeFirstResponder()
      }
    }
    cell.setText("")
    
    return cell
  }
}

extension SheetViewController: SheetEditCellDelegate {
  func completedEditing(inView view: SheetEditCell, resolution: SheetEditCell.Resolution) {
    view.resignFirstResponder()
    guard let coordinate = self.selectedLocation else {
      return
    }

    let res: String
    switch resolution {
    case .commit(.Some(let value)):
      res = "commit value \(value)"
    case .commit(.None):
      res = "clear value at location"
    case .cancel:
      res = "canceled"
    }
    print("Edit Resolved \(res)")
    let indexPath = NSIndexPath(forItem: coordinate.column, inSection: coordinate.row)
    self.selectedLocation = nil
    self.collectionView.reloadItemsAtIndexPaths([indexPath])
  }
}
