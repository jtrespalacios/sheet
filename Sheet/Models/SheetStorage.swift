//
//  SheetBackModel.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/16/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

struct SheetStorage {
  enum Error: ErrorType {
    case outOfBoundsAccess
  }
  static let defaultDimension = 8
  var columns: Int
  var rows: Int
  var data: [[String?]]

  init(columns: Int = SheetStorage.defaultDimension, rows: Int = SheetStorage.defaultDimension, data: [[String?]]? = nil, initialValue: String? = nil) {
    self.columns = columns
    self.rows = rows
    self.data = Array<[String?]>(count: columns, repeatedValue: Array<String?>(count: rows, repeatedValue: initialValue))
  }

  func getValue(fromColumn column: Int, row: Int) throws -> String? {
    guard column >= 0 && column < self.columns &&
      row >= 0 && row < self.rows else {
        throw Error.outOfBoundsAccess
    }
    return self.data[column][row]
  }
}
