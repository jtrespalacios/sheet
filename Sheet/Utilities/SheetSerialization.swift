//
//  SheetSerialization.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/19/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import Foundation

class SheetSerializer: NSObject, NSCoding {
  private static let rowsKey = "co.j3p.Sheets.SheetSerializer.rows"
  private static let colsKey = "co.j3p.Sheets.SheetSerializer.columns"
  private static let dataKey = "co.j3p.Sheets.SheetSerializer.data"
  private var sheetStorage: SheetStorage

  init(storage: SheetStorage) {
    self.sheetStorage = storage
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    let rows = aDecoder.decodeIntegerForKey(SheetSerializer.rowsKey)
    let columns = aDecoder.decodeIntegerForKey(SheetSerializer.colsKey)
    let sheetData: [Coordinate: String]?
    if let data = aDecoder.decodeObjectForKey(SheetSerializer.dataKey) as? [String: String]{
      var savedData = [Coordinate: String]()
      for (key, value) in data {
        if let coord = SheetSerializer.coordinate(fromString: key) {
          savedData[coord] = value
        }
      }
      sheetData = savedData
    } else {
      sheetData = nil
    }
    let storage = SheetStorage(columns: columns, rows: rows, data: sheetData)
    self.sheetStorage = storage
    super.init()
  }

  static private func coordinate(fromString string: String) -> Coordinate? {
    let components: [String] = string.componentsSeparatedByString(",")
    guard components.count == 2, let row = Int(components[0]), let column = Int(components[1]) else {
      return nil
    }
    return Coordinate(row: row, column: column)
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(self.sheetStorage.rows, forKey: SheetSerializer.rowsKey)
    aCoder.encodeInteger(self.sheetStorage.columns, forKey: SheetSerializer.colsKey)

    guard let allKeys = self.sheetStorage.allKeys else {
      aCoder.encodeObject(nil, forKey: SheetSerializer.dataKey)
      return
    }

    var data = [String: String]()
    for key in allKeys {
      let keyString = "\(key.row),\(key.column)"
      if let value = try? self.sheetStorage.getValue(fromCoordinate: key) {
        data[keyString] = value
      }
    }

    aCoder.encodeObject(data as AnyObject, forKey: SheetSerializer.dataKey)
  }

  static func writeToDisk(sheet: SheetStorage) -> Bool {
    let serializer = SheetSerializer(storage: sheet)
    return NSKeyedArchiver.archiveRootObject(serializer, toFile: self.path())
  }

  static func loadFromDisk() -> SheetStorage? {
    guard let sheetSerializer = NSKeyedUnarchiver.unarchiveObjectWithFile(self.path()) as? SheetSerializer else {
      return nil
    }

    return sheetSerializer.sheetStorage
  }

  private static func path() -> String {
    let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
    let path = documentsPath?.stringByAppendingString("/Sheet")
    return path!
  }
}