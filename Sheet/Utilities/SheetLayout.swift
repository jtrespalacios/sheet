//
//  SheetLayout.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

public class SheetLayout: UICollectionViewLayout {
  public static let defaultDimensions = 8
  public static let defaultSize = CGSize(width: 125, height: 50)
  public let rows: Int
  public let columns: Int
  public let itemSize: CGSize

  init(itemSize: CGSize = SheetLayout.defaultSize, rows: Int = SheetLayout.defaultDimensions, columns: Int = SheetLayout.defaultDimensions) {
    self.rows = rows
    self.columns = columns
    self.itemSize = itemSize
    super.init()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func collectionViewContentSize() -> CGSize {
    let width = CGFloat(self.columns) * self.itemSize.width
    let height = CGFloat(self.rows) * self.itemSize.height
    return CGSize(width: width, height: height)
  }

  public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return nil
  }

  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return nil
  }
}
