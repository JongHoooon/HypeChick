//
//  GroupDetailCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit

final class GroupDetailCell: UICollectionViewCell {
  
  lazy var memberImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "smallChick")
  }
  
  private lazy var memberNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.text = "김홍익"
  }
  
  private lazy var memberTimeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.text = "00:00:00"
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Method

extension GroupDetailCell {
  
  func configureCell(_ testGroup: TestGroup) {
    self.memberImageView.image = UIImage(named: testGroup.imageName)
    self.memberNameLabel.text = testGroup.name
    self.memberTimeLabel.text = testGroup.time
  }
  
  private func configureUI() {
    
    backgroundColor = .systemBackground
    
    [
      memberImageView,
      memberNameLabel,
      memberTimeLabel
    ].forEach { addSubview($0) }
  
    memberImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16.0)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(88.0)
    }
    
    memberNameLabel.snp.makeConstraints {
      $0.top.equalTo(memberImageView.snp.bottom).offset(8.0)
      $0.centerX.equalToSuperview()
    }
    
    memberTimeLabel.snp.makeConstraints {
      $0.top.equalTo(memberNameLabel.snp.bottom).offset(4.0)
      $0.centerX.equalToSuperview()
    }
  }
}

