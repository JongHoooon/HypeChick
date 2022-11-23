//
//  PurposePresentView.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/23.
//

import UIKit
import SnapKit
import Then

class PurposePresentView: UIView {
  
  lazy var purposeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17.0)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.textAlignment = .center
  }
  
  lazy var imageView = UIImageView().then {
    $0.image = UIImage(systemName: "chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    backgroundColor = UIColor.defaultTintColor
    
    [
      imageView,
      purposeLabel
    ].forEach { addSubview($0) }
    
    imageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16.0)
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(16.0)
    }
    
    purposeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(40.0)
      $0.trailing.equalTo(imageView.snp.leading).offset(-8.0)
      $0.centerY.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
