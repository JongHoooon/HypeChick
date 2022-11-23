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
  
  var width: CGFloat
  
  lazy var nilImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "noGroup")
  }
  
  lazy var bubbleImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(named: "noGroupBubble")
  }
  
  lazy var nilLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 36.0)
    $0.textColor = .label
    $0.numberOfLines = 0
    //    $0.text = "가입한 그룹이 없습니다!"
    $0.textAlignment = .center
  }
  
  init(width: CGFloat) {
    self.width = width
    
    super.init(frame: .zero)
    
    self.backgroundColor = .systemBackground
    
    [
      nilImageView,
      bubbleImageView,
      nilLabel
    ].forEach { addSubview($0) }
    
    nilImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.width.equalTo(width)
      $0.bottom.equalToSuperview().inset(width/4)
    }
    
    bubbleImageView.snp.makeConstraints {
      $0.bottom.equalTo(nilImageView.snp.top).offset(width/3)
      $0.leading.trailing.equalToSuperview().inset(32.0)
      $0.height.equalTo(width/3)
    }
    
    nilLabel.snp.makeConstraints {
      $0.centerY.equalTo(bubbleImageView.snp.centerY)
      $0.leading.trailing.equalTo(bubbleImageView).offset(16.0)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
