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
  private let defaultSheetDimension = 8
  weak var toolbar: UIToolbar!
  weak var undoButton: UIBarButtonItem!
  weak var collectionView: UICollectionView!
  weak var addRowButton: UIButton!
  weak var addColumnButton: UIButton!
  private var selectedLocation: Coordinate?
  private var storage: SheetStorage!
  private var sheetUndoManager = SheetUndoManager()

  override func loadView() {
    let view = UIView(frame: .zero)
    let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: #selector(SheetViewController.undo))
    let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(SheetViewController.save))
    let addRowButton = UIButton(type: .System)
    let addColumnButton = UIButton(type: .System)
    let spaceItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let toolbar = UIToolbar(frame: .zero)
    let layout = SheetLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    addRowButton.setTitle("Add Row", forState: .Normal)
    addRowButton.translatesAutoresizingMaskIntoConstraints = false
    addRowButton.sizeToFit()
    addRowButton.addTarget(self, action: #selector(SheetViewController.addRow), forControlEvents: .TouchUpInside)
    addColumnButton.setTitle("Add Column", forState: .Normal)
    addColumnButton.translatesAutoresizingMaskIntoConstraints = false
    addColumnButton.sizeToFit()
    addColumnButton.addTarget(self, action: #selector(SheetViewController.addColumn), forControlEvents: .TouchUpInside)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.allowsSelection = true
    collectionView.allowsMultipleSelection = false
    collectionView.bounces = false
    undoButton.enabled = false
    toolbar.items = [saveButton, spaceItem, undoButton]
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(toolbar)
    view.addSubview(collectionView)
    view.backgroundColor = UIColor.whiteColor()
    view.addSubview(addRowButton)
    view.addSubview(addColumnButton)

    self.view = view
    self.undoButton = undoButton
    self.collectionView = collectionView
    self.toolbar = toolbar
    self.addRowButton = addRowButton
    self.addColumnButton = addColumnButton
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Sheet"
    let views = [
      "cv": self.collectionView,
      "tb": self.toolbar,
      "arb": self.addRowButton,
      "acb": self.addColumnButton,
      "tlg": self.topLayoutGuide as AnyObject
    ]
    let formatStrings = [ "H:|[tb]|", "H:|[cv]|", "H:[arb]-[acb]-|", "V:[tlg]-[arb]-[cv][tb]|" ]
    self.view.addConstraints(visualFormatStrings: formatStrings, options: [], metrics: nil, views: views)
    self.addColumnButton.centerYAnchor.constraintEqualToAnchor(self.addRowButton.centerYAnchor).active = true
    self.collectionView.registerClass(SheetCell.self, forCellWithReuseIdentifier: SheetCell.reuseIdentifier)
    self.collectionView.registerClass(SheetEditCell.self, forCellWithReuseIdentifier: SheetEditCell.reuseIdentifier)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self

    self.storage = SheetSerializer.loadFromDisk()
    if self.storage == nil {
      self.storage = SheetStorage(columns: self.defaultSheetDimension, rows: self.defaultSheetDimension)
    }
  }

  func undo() { }

  func save() {
    if !SheetSerializer.writeToDisk(self.storage) {
      print("Failed to write sheet to disk")
    }
  }

  func addRow() {
    self.collectionView.performBatchUpdates({
      self.storage.addRow()
      let newRow = self.storage.rows - 1
      self.collectionView.insertSections(NSIndexSet(index: newRow))
      }, completion: nil)
  }

  func addColumn() {
    self.collectionView.performBatchUpdates({
      self.storage.addColumn()
      let newColumn = self.storage.columns - 1
      var newIndexes = [NSIndexPath]()
      for i in 0 ..< self.storage.rows {
        newIndexes.append(NSIndexPath(forItem: newColumn, inSection: i))
      }
      self.collectionView.insertItemsAtIndexPaths(newIndexes)
      }, completion: nil)
  }
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
    return self.storage.rows
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.storage.columns
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

    let coord = Coordinate(indexPath: indexPath)
    if let value = try? self.storage.getValue(fromCoordinate: coord) {
      cell.setText(value)
    }

    return cell
  }
}

extension SheetViewController: SheetEditCellDelegate {
  func completedEditing(inView view: SheetEditCell, resolution: SheetEditCell.Resolution) {
    view.resignFirstResponder()
    guard let coordinate = self.selectedLocation else {
      return
    }

    func savePreviousValueToHistory() {
      if let previousValue = try? self.storage.getValue(fromCoordinate: coordinate) {
        self.sheetUndoManager.logChange(atCoordinate: coordinate, value: previousValue)
      }
    }

    switch resolution {
    case .commit(.Some(let value)):
      savePreviousValueToHistory()
      _ = try? self.storage.setValue(atCoordinate: coordinate, content: value)
    case .commit(.None):
      savePreviousValueToHistory()
      _ = try? self.storage.setValue(atCoordinate: coordinate, content: nil)
    case .cancel:
      break; // do nothing
    }

    let indexPath = NSIndexPath(forItem: coordinate.column, inSection: coordinate.row)
    self.selectedLocation = nil
    self.collectionView.reloadItemsAtIndexPaths([indexPath])
  }
}
