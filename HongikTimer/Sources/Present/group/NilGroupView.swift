//
//  NilGroupView.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/22.
//

import UIKit
import SnapKit
import Then

final class NilGroupView: UIView {
  
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    self.backgroundColor = .gray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
