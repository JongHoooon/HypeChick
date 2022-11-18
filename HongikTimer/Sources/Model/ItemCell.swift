//
//  ItemCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import Foundation
import UIKit

struct ItemCell {
  let name: String
  let image: UIImage?
  
  init(_ name: String, imageName: String) {
    self.name = name
    self.image = UIImage(named: imageName)
  }
}
