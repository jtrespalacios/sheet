//
//  SheetUndoManager.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/18/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

class SheetUndoManager: UndoManager {
  private var undoStack = [(Coordinate, String?)]()

  func logChange(atCoordinate coordinate: Coordinate, value: String?) {
    self.undoStack.append((coordinate, value))
  }

  func lastValue() -> (Coordinate, String?)? {
    return self.undoStack.popLast()
  }

  func clearHistory() {
    self.undoStack = [(Coordinate, String?)]()
  }

  func historyAvailable() -> Bool {
    return self.undoStack.count > 0
  }
}