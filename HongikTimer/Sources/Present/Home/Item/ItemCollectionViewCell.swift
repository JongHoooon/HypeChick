//
//  ItemCollectionViewCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import Foundation
import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
  
  lazy var categoyImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit

  }
  
  lazy var categoryLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12.0, weight: .medium)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    backgroundColor = .systemBackground
    
    [
      categoyImageView,
      categoryLabel
    ].forEach { addSubview($0) }
    
    categoyImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16.0)
      $0.height.equalTo(32.0)
      $0.width.equalTo(28.0)
      $0.centerX.equalToSuperview()
    }
    
    categoryLabel.snp.makeConstraints {
      $0.top.equalTo(categoyImageView.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(with item: ItemCell) {
    self.categoryLabel.text = item.name
    self.categoyImageView.image = item.image
  }
  
}
