//
//  UIColor+Extension.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/14.
//

import UIKit

extension UIColor {
  static let defaultTintColor = UIColor.init(rgb: 0x89cff0)
  static let timerGreen = UIColor.init(rgb: 0x8bc86b)
  static let barTint = UIColor.label
  
  struct Social {
    static let naverGreen = UIColor(red: 3, green: 199, blue: 90)
    static let kakaoYellow = UIColor(red: 247, green: 230, blue: 0)
    static let kakaoBrown = UIColor(red: 58, green: 29, blue: 29)
  }
}

extension UIColor {    
  convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
    self.init(
      red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: CGFloat(a) / 255.0
    )
  }
  
  /// HEX 변환
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  
  /// HEX 변환 with alpha
  convenience init(argb: Int) {
    self.init(
      red: (argb >> 16) & 0xFF,
      green: (argb >> 8) & 0xFF,
      blue: argb & 0xFF,
      a: (argb >> 24) & 0xFF
    )
  }
}
