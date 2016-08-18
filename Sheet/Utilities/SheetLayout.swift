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
  public let itemSize: CGSize

  init(itemSize: CGSize = SheetLayout.defaultSize) {
    self.itemSize = itemSize
    super.init()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func collectionViewContentSize() -> CGSize {
    let (rows, columns) = getSectionsAndItems()
    let width = CGFloat(columns) * self.itemSize.width
    let height = CGFloat(rows) * self.itemSize.height
    return CGSize(width: width, height: height)
  }

  public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let visibleIndexPaths = indexPathsVisible(inRect: rect)
    guard visibleIndexPaths.count > 0 else {
      return nil
    }
    var attributes = [UICollectionViewLayoutAttributes]()
    visibleIndexPaths.forEach {
      if let attr = self.layoutAttributesForItemAtIndexPath($0) {
        attributes.append(attr)
      }
    }

    return attributes
  }

  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let (rows, columns) = getSectionsAndItems()
    let section = indexPath.section // Row
    let item = indexPath.item // Column
    guard section >= 0 && section < rows && item >= 0 && item < columns else {
      return nil
    }

    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    let centerY = floor((CGFloat(section) + 0.5) * self.itemSize.height)
    let centerX = floor((CGFloat(item) + 0.5) * self.itemSize.width)
    attributes.size = itemSize
    attributes.center = CGPoint(x: centerX, y: centerY)
    return attributes
  }

  private func indexPathsVisible(inRect rect: CGRect) -> [NSIndexPath] {
    var indexPaths = [NSIndexPath]()
    let origin = rect.origin
    let maxExtent = CGPoint(x: rect.maxX, y: rect.maxY)

    let startSection = Int(floor(origin.y / itemSize.height))
    let startItem = Int(floor(origin.x / itemSize.width))
    let endSection = Int(floor(maxExtent.y / itemSize.height))
    let endItem = Int(floor(maxExtent.x / itemSize.width))

    for section in startSection ... endSection {
      for item in startItem ... endItem {
        indexPaths.append(NSIndexPath(forItem: item, inSection: section))
      }
    }

    return indexPaths
  }

  private func getSectionsAndItems() -> (Int, Int) {
    guard let cv = collectionView else {
        fatalError("Attempted to get number of sections and items but no collection view available")
    }
    let rows = cv.numberOfSections()
    let columns = cv.numberOfItemsInSection(0)
    return (rows, columns)
  }
}
