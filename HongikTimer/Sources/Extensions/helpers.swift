//
//  helpers.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/04.
//

import UIKit

func makeLabel(
  _ title: String,
  content: String
) -> NSMutableAttributedString {
  let result = NSMutableAttributedString(
    string: title,
    attributes: [ .foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 12.0)]
  )
  result.append(NSAttributedString(string: " "))
  result.append(NSMutableAttributedString(
    string: content,
    attributes: [ .foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 12.0)])
  )
  return result
}
