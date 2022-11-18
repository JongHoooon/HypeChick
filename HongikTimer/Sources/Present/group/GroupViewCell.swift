//
//  GroupViewCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit

final class GroupViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  private lazy var titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16.0, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  private lazy var categoryLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }
  
  private lazy var memberCountLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }
  
  private lazy var chiefLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 1
  }
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configreLayout()
    
    titleLabel.text = "스위프트 코딩테스트 스터디"
    categoryLabel.text = "스터디그룹 ・ 대학생"
    memberCountLabel.text = "50/41명"
    chiefLabel.text = "김홍익"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Method

private extension GroupViewCell {
  
  func configreLayout() {
    
    backgroundColor = .systemBackground
    
    [
      titleLabel,
      categoryLabel,
      memberCountLabel,
      chiefLabel
    ].forEach { addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
    }
    
    categoryLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
    }
    
    memberCountLabel.snp.makeConstraints {
      $0.top.equalTo(categoryLabel.snp.bottom).offset(4.0)
      $0.leading.equalTo(titleLabel)
    }
    
//    chiefLabel.snp.makeConstraints {
//      $0.top.equalTo(memberCountLabel)
//      $0.leading.equalTo(memberCountLabel.snp.bottom).offset(4.0)
//    }
  }
  
}
