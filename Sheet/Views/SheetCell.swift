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
    self.backgroundView = UIView(frame: self.bounds)
    self.backgroundView?.layer.borderColor = UIColor.darkGrayColor().CGColor
    self.backgroundView?.layer.borderWidth = 1
    self.backgroundView?.backgroundColor = UIColor.whiteColor()
    self.selectedBackgroundView = UIView(frame: self.bounds)
    self.selectedBackgroundView?.layer.borderColor = UIColor.orangeColor().CGColor
    self.selectedBackgroundView?.layer.borderWidth = 1
    self.selectedBackgroundView?.backgroundColor = UIColor.whiteColor()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.textLabel.text = nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
