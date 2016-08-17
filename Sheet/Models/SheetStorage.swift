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

  public var columns: Int
  public var rows: Int
  private var data: [Coordinate: String]

  init(columns: Int = SheetStorage.defaultDimension, rows: Int = SheetStorage.defaultDimension, data: [Coordinate: String]? = nil) {
    self.columns = columns
    self.rows = rows
    if let data = data {
      self.data = data
    } else {
      self.data = [Coordinate: String]()
    }
  }

  func getValue(fromColumn column: Int, row: Int) throws -> String? {
    guard column >= 0 && column < self.columns &&
      row >= 0 && row < self.rows else {
        throw Error.outOfBoundsAccess
    }
    let coordinate = Coordinate(row: row, column: column)
    return self.data[coordinate]
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
}

public func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
  return lhs.row == rhs.row && lhs.column == rhs.column
}