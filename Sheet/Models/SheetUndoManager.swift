//
//  SheetUndoManager.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/18/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

class SheetUndoManager: UndoManager {
  var undoStack = [Coordinate: [String?]]()

  func logChange(atCoordinate coordinate: Coordinate, value: String?) {

  }

  func lastValue(forCoordinate coordinate: Coordinate) -> String? {
    return nil
  }

  func historyAvailable(forCoordinate coordinate: Coordinate) -> Bool {
    return false
  }
}