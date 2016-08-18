//
//  SheetCell.swift
//  Sheet
//
//  Created by Jeffery Trespalacios on 8/17/16.
//  Copyright © 2016 Jeffery Trespalacios. All rights reserved.
//

import UIKit

class SheetCell: UICollectionViewCell {
  static let reuseIdentifier = "co.j3p.Sheet.SheetCell"
  
  weak var textLabel: UILabel!

  override init(frame: CGRect) {
    let label = UILabel(frame: .zero)
    self.textLabel = label
    super.init(frame: frame)
    self.contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    let formatStrings = ["H:|-(>=8)-[lb]-(>=8)-|", "V:|-(>=8)-[lb]-(>=8)-|"]
    self.contentView.addConstraints(visualFormatStrings: formatStrings, options: [], metrics: nil, views: ["lb": label])
    label.centerXAnchor.constraintEqualToAnchor(self.contentView.centerXAnchor).active = true
    label.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
    self.contentView.layer.borderColor = UIColor.darkGrayColor().CGColor
    self.contentView.layer.borderWidth = 1
    self.backgroundColor = UIColor.whiteColor()
  }

  override func prepareForReuse() {
    self.textLabel.text = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
