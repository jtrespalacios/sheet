//
//  SheetUndoManager.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/18/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

class SheetUndoManager: UndoManager {
  private var undoStack = [Coordinate: [String?]]()

  func logChange(atCoordinate coordinate: Coordinate, value: String?) {
    var itemHistory: [String?]

    if let stack = self.undoStack[coordinate] {
      itemHistory = stack
    } else {
      itemHistory = [String?]()
    }
    itemHistory.append(value)
    self.undoStack[coordinate] = itemHistory
  }

  func lastValue(forCoordinate coordinate: Coordinate) -> String? {
    var value: String?
    if var itemHistory = self.undoStack[coordinate] {
      if let lastValue = itemHistory.popLast() {
        value = lastValue
        if itemHistory.count > 0 {
          self.undoStack[coordinate] = itemHistory
        } else {
          self.undoStack.removeValueForKey(coordinate)
        }
      }
    }
    return value
  }

  func historyAvailable(forCoordinate coordinate: Coordinate) -> Bool {
    return self.undoStack[coordinate] != nil
  }
}