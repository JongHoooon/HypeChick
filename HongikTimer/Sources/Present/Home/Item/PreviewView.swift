//
//  PreviewView.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit
import Then
import SnapKit

final class PreviewView: UIView {
  
  // MARK: - Property
  lazy var wallImageView = UIImageView().then {
    $0.contentMode = .scaleToFill
  }
  
  lazy var chickImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
  
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Method

private extension PreviewView {
  func configureLayout() {
    [
      wallImageView,
      chickImageView
    ].forEach { addSubview($0) }
    
    wallImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    chickImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(100.0)
      $0.bottom.equalTo(wallImageView.snp.bottom).offset(-80.0)
    }
    
  }
}
