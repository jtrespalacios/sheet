//
//  UIView+Helpers.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

extension UIView {
  public func addConstraints(visualFormatStrings strings: [String], options opts: NSLayoutFormatOptions, metrics: [String: AnyObject]?, views: [String: AnyObject]) {
    for s in strings {
      self.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(s, options: opts, metrics: metrics, views: views)
      )
    }
  }
}