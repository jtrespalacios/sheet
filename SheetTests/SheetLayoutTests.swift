//
//  SheeLayoutTests.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import XCTest
@testable import Sheet

class SheetLayoutTests: XCTestCase {
  static let numberOfRows = 5
  static let numberOfCols = 10
  func testDefaultLayoutReturnsCorrectContentSize() {
    let standardLayout = SheetLayout()
    let ds = MockDataSource()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: standardLayout)
    cv.dataSource = ds

    let standardWitdh = CGFloat(SheetLayoutTests.numberOfCols) * SheetLayout.defaultSize.width
    let standardHeight = CGFloat(SheetLayoutTests.numberOfRows) * SheetLayout.defaultSize.height
    let standardDimensions = CGSize(width: standardWitdh, height: standardHeight)
    XCTAssertTrue(CGSizeEqualToSize(standardDimensions, standardLayout.collectionViewContentSize()), "A standard sheet layout should have a size matching its default values")
  }

  func testCustomizedLayoutReturnsCorrectContentSize() {
    let size = CGSize(width: 20, height: 20)
    let knownSize = CGSize(width: SheetLayoutTests.numberOfCols * 20, height: SheetLayoutTests.numberOfRows * 20)
    let layout = SheetLayout(itemSize: size)
    let ds = MockDataSource()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.dataSource = ds
    XCTAssertTrue(CGSizeEqualToSize(knownSize, layout.collectionViewContentSize()), "A customized sheet layout should return the correct content size")
  }

  class MockDataSource: NSObject, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
      return SheetLayoutTests.numberOfRows
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return SheetLayoutTests.numberOfCols
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
    }
  }
}
