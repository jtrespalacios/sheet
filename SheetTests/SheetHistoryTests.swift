//
//  SheetHistoryTests.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/18/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import XCTest
@testable import Sheet

class SheetHistoryTests: XCTestCase {
  var sheetUndoManager: SheetUndoManager!

  override func setUp() {
    super.setUp()
    self.sheetUndoManager = SheetUndoManager()
  }

  override func tearDown() {
    super.tearDown()
    self.sheetUndoManager = nil
  }

  func testEmptyUndoManagerHasNoHistory() {
    let hasHistory = self.sheetUndoManager.historyAvailable()
    XCTAssertFalse(hasHistory, "An empty sheet undo manager should have no history")
  }

  func testUndoManagerWithSingleHistoryRecordLogged() {
    let testValue = "Test"
    let coordinate = Coordinate(row: 0, column: 0)
    self.sheetUndoManager.logChange(atCoordinate: coordinate, value: testValue)
    let hasHistory = self.sheetUndoManager.historyAvailable()
    let loggedValue = self.sheetUndoManager.lastValue()
    XCTAssertTrue(hasHistory, "A sheet manager that has had a value logged for a coordinate will have history available")
    XCTAssertEqual(testValue, loggedValue?.1, "A sheet manager should return the correct value for a coordinates history")
  }

  func testUndoManagerWithMultipleHistoryRecordsLogged() {
    let testValue1 = "Hello"
    let testValue2 = "World"
    let testValue3 = "Pizza"
    let coord1 = Coordinate(row: 0, column: 0)
    let coord2 = Coordinate(row: 1, column: 1)
    [testValue1, testValue2, testValue3].forEach { self.sheetUndoManager.logChange(atCoordinate: coord1, value: $0) }
    [testValue3, testValue2, testValue1].forEach { self.sheetUndoManager.logChange(atCoordinate: coord2, value: $0) }

    let coordTwoLasValue = self.sheetUndoManager.lastValue()!
    XCTAssertEqual(coordTwoLasValue.0, coord2, "The last value saved should be for coordinate (1, 1)")
    XCTAssertEqual(coordTwoLasValue.1, testValue1, "The last value saved should have a string of \(testValue1)")
  }

  func testClearingUndoHistory() {
    let coord = Coordinate(row: 0, column: 0)
    let value = "Test"
    self.sheetUndoManager.logChange(atCoordinate: coord, value: value)
    self.sheetUndoManager.clearHistory()
    let hasHistory = self.sheetUndoManager.historyAvailable()
    XCTAssertFalse(hasHistory, "After clearing history there should be no data available")
  }
}
