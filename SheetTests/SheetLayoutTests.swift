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

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testDefaultLayoutReturnsCorrectContentSize() {
    let standardLayout = SheetLayout()
    let standardWitdh = CGFloat(SheetLayout.defaultDimensions) * SheetLayout.defaultSize.width
    let standardHeight = CGFloat(SheetLayout.defaultDimensions) * SheetLayout.defaultSize.height
    let standardDimensions = CGSize(width: standardWitdh, height: standardHeight)
    XCTAssertTrue(CGSizeEqualToSize(standardDimensions, standardLayout.collectionViewContentSize()), "A standard sheet layout should have a size matching its default values")
  }

  func testCustomizedLayoutReturnsCorrectContentSize() {
    let size = CGSize(width: 20, height: 20)
    let rows = 5
    let cols = 10
    let knownSize = CGSize(width: 10 * 20, height: 5 * 20)
    let layout = SheetLayout(itemSize: size, rows: rows, columns: cols)
    XCTAssertTrue(CGSizeEqualToSize(knownSize, layout.collectionViewContentSize()), "A customized sheet layout should return the correct content size")
  }
}
