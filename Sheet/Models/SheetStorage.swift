//
//  SheetBackModel.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/16/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

public struct SheetStorage {

  static let defaultDimension = 8
  public enum Error: ErrorType {
    case outOfBoundsAccess
  }

  public var columns: Int {
    return internalColumns
  }
  private var internalColumns: Int
  public var rows: Int {
    return internalRows
  }
  private var internalRows: Int

  var allKeys: [Coordinate]? {
    return Array(data.keys)
  }

  private var data: [Coordinate: String]

  init(columns: Int = SheetStorage.defaultDimension, rows: Int = SheetStorage.defaultDimension, data: [Coordinate: String]? = nil) {
    self.internalColumns = columns
    self.internalRows = rows
    if let data = data {
      self.data = data
    } else {
      self.data = [Coordinate: String]()
    }
  }

  func getValue(fromCoordinate coordinate: Coordinate) throws -> String? {
    return try self.getValue(fromColumn: coordinate.column, row: coordinate.row)
  }

  func getValue(fromColumn column: Int, row: Int) throws -> String? {
    guard column >= 0 && column < self.columns &&
      row >= 0 && row < self.rows else {
        throw Error.outOfBoundsAccess
    }
    let coordinate = Coordinate(row: row, column: column)
    return self.data[coordinate]
  }

  mutating func addRow() {
    self.internalRows += 1
  }

  mutating func addColumn() {
    self.internalColumns += 1
  }

  mutating func setValue(atCoordinate coordinate: Coordinate, content: String?) throws {
    try self.setValue(atRow: coordinate.row, column: coordinate.column, content: content)
  }

  mutating func setValue(atRow row: Int, column: Int, content: String?) throws {
    guard column >= 0 && column < self.columns &&
      row >= 0 && row < self.rows else {
        throw Error.outOfBoundsAccess
    }
    let coordinate = Coordinate(row: row, column: column)
    guard let content = content else {
      self.data.removeValueForKey(coordinate)
      return
    }
    self.data[coordinate] = content
  }
}


public struct Coordinate: Hashable, Equatable {
  public let row: Int
  public let column: Int

  public var hashValue: Int {
    return (51 + self.row.hashValue) * 51 + self.column.hashValue
  }

  init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }

  init(indexPath: NSIndexPath) {
    self.row = indexPath.section
    self.column = indexPath.item
  }
}

public func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
  return lhs.row == rhs.row && lhs.column == rhs.column
}

extension NSIndexPath {
  convenience init(coordinate: Coordinate) {
    self.init(forItem: coordinate.column, inSection: coordinate.row)
  }
}