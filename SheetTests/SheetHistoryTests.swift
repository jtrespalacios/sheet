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
    let coordinate = Coordinate(row: 0, column: 0)
    let hasHistory = self.sheetUndoManager.historyAvailable(forCoordinate: coordinate)
    XCTAssertFalse(hasHistory, "An empty sheet undo manager should have no history")
  }

  func testUndoManagerWithSingleHistoryRecordLogged() {
    let testValue = "Test"
    let coordinate = Coordinate(row: 0, column: 0)
    self.sheetUndoManager.logChange(atCoordinate: coordinate, value: testValue)
    let hasHistory = self.sheetUndoManager.historyAvailable(forCoordinate: coordinate)
    let loggedValue = self.sheetUndoManager.lastValue(forCoordinate: coordinate)
    XCTAssertTrue(hasHistory, "A sheet manager that has had a value logged for a coordinate will have history available")
    XCTAssertEqual(testValue, loggedValue, "A sheet manager should return the correct value for a coordinates history")
  }

  func testUndoManagerWithMultipleHistoryRecordsLogged() {
    let testValue1 = "Hello"
    let testValue2 = "World"
    let testValue3 = "Pizza"
    let coord1 = Coordinate(row: 0, column: 0)
    let coord2 = Coordinate(row: 1, column: 1)
    [testValue1, testValue2, testValue3].forEach { self.sheetUndoManager.logChange(atCoordinate: coord1, value: $0) }
    [testValue3, testValue2, testValue1].forEach { self.sheetUndoManager.logChange(atCoordinate: coord2, value: $0) }

    let coordOneLastValue = self.sheetUndoManager.lastValue(forCoordinate: coord1)
    let coordTwoLastValue = self.sheetUndoManager.lastValue(forCoordinate: coord2)

    XCTAssertEqual(coordOneLastValue, testValue3, "The last value for coordinate one should be \(testValue3)")
    XCTAssertEqual(coordTwoLastValue, testValue1, "The last value for coordinate one should be \(testValue1)")

    let coordOneSecondValue = self.sheetUndoManager.lastValue(forCoordinate: coord1)
    let coordTwoSecondValue = self.sheetUndoManager.lastValue(forCoordinate: coord2)

    XCTAssertEqual(coordOneSecondValue, testValue2, "The last value for coordinate one should be \(testValue2)")
    XCTAssertEqual(coordTwoSecondValue, testValue2, "The last value for coordinate one should be \(testValue2)")

    let coordOneFirstValue = self.sheetUndoManager.lastValue(forCoordinate: coord1)
    let coordTwoFirstValue = self.sheetUndoManager.lastValue(forCoordinate: coord2)

    XCTAssertEqual(coordOneFirstValue, testValue1, "The last value for coordinate one should be \(testValue1)")
    XCTAssertEqual(coordTwoFirstValue, testValue3, "The last value for coordinate one should be \(testValue3)")

    let coordOneHasHistory = self.sheetUndoManager.historyAvailable(forCoordinate: coord1)
    let coordTwoHasHistory = self.sheetUndoManager.historyAvailable(forCoordinate: coord2)

    XCTAssertFalse(coordOneHasHistory, "After clearing all values from manager, there should be no history available")
    XCTAssertFalse(coordTwoHasHistory, "After clearing all values from manager, there should be no history available")
  }
}
