//
//  SheetTests.swift
//  SheetTests
//
//  Created by Jeffery Trespalacios on 8/16/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import XCTest
@testable import Sheet

class SheetTests: XCTestCase {

  func testSheetStorageDefaultInitializer() {
    let storage = SheetStorage()
    for c in 0 ..< 8 {
      for r in 0 ..< 8 {
        do {
          let value = try storage.getValue(fromColumn: c, row: r)
          XCTAssertNil(value, "Value at (\(c), \(r)) should be nil using the default initializer")
        } catch {
          XCTFail("Out of bounds access should not be thrown")
        }
      }
    }
  }

  func testSheetStorageProvidedDefaultValue() {
    let storage = SheetStorage(initialValue: "")
    for c in 0 ..< 8 {
      for r in 0 ..< 8 {
        do {
          let value = try storage.getValue(fromColumn: c, row: r)
          XCTAssertEqual(value, "", "Value at (\(c), \(r)) should be the empty string")
        } catch {
          XCTFail("Out of bounds access should not be thrown")
        }
      }
    }
  }

  func testCustomDimensionSheetStorage() {
    let columns = 5
    let rows = 3
    let storage = SheetStorage(columns: columns, rows: rows)
    for c in 0 ..< columns {
      for r in 0 ..< rows {
        do {
          let value = try storage.getValue(fromColumn: c, row: r)
          XCTAssertNil(value, "Value at (\(c), \(r)) should be nil")
        } catch {
          XCTFail("Out of bounds access should not be thrown")
        }
      }
    }
  }

  func testColumnOutOfBoundsAccess() {
    let storage = SheetStorage()
    do {
      _ = try storage.getValue(fromColumn: 100, row: 5)
      XCTFail("Accessing an out of bounds column should have thrown an exception")
    } catch {
      print("Failed to access out of bounds column")
    }
  }

  func testRowOutOfBoundsAccess() {
    let storage = SheetStorage()
    do {
      _ = try storage.getValue(fromColumn: 5, row: 100)
      XCTFail("Accessing an out of bounds row should have thrown an exception")
    } catch {
      print("Failed to access out of bounds row")
    }
  }
}
