//
//  BoardViewCell.swift
//  10-2-home
//
//  Created by JongHoon on 2022/10/15.
//

import Then
import SnapKit
import UIKit
import ReactorKit
import RxSwift

final class BoardViewCell: UICollectionViewCell, View {
  
  var disposeBag = DisposeBag()
  
  // MARK: - UI
  
  private lazy var titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16.0, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  private lazy var memberLabel = UILabel()

  lazy var chiefLabel = UILabel()
  
  lazy var startDayLabel = UILabel()
  
  lazy var totalTimeLabel = UILabel()
  
  private lazy var contentLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 2
  }
  
  private lazy var separatorView = UIView().then {
    $0.backgroundColor = .quaternaryLabel
  }
  
  // MARK: - Initalizing
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    self.configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Binding
  
  func bind(reactor: BoardViewCellReactor) {
    self.titleLabel.text = reactor.currentState.title
    self.memberLabel.attributedText = makeLabel(
      "인원",
      content: "\(reactor.currentState.memberCount)/\(reactor.currentState.maxMemberCount)명" )
    self.chiefLabel.attributedText = makeLabel("그룹장", content: reactor.currentState.chief)
    self.startDayLabel.attributedText = makeLabel("시작일", content: reactor.currentState.startDay)
    self.totalTimeLabel.attributedText = makeLabel("총 시간", content: "\(reactor.currentState.totalTime%3600)시간")
    self.contentLabel.text = reactor.currentState.content
  }
}

// MARK: - Private

private extension BoardViewCell {
  
  func configureLayout() {
    
    let firstLineStackView = UIStackView(arrangedSubviews: [
      memberLabel,
      chiefLabel
    ]).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 0
    }
    
    let secondLineStackView = UIStackView(arrangedSubviews: [
      startDayLabel,
      totalTimeLabel
    ]).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 0
    }
    
    [
//      categoryLabel,
      titleLabel,
      firstLineStackView,
      secondLineStackView,
      separatorView,
      contentLabel
    ].forEach { addSubview($0) }
    
//    categoryLabel.snp.makeConstraints {
//      $0.leading.equalToSuperview().inset(16.0)
//      $0.top.equalToSuperview().inset(16.0)
//    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16.0)
      $0.top.equalToSuperview().inset(16.0)
    }
    
    firstLineStackView.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
    }
    
    secondLineStackView.snp.makeConstraints {
      $0.leading.equalTo(firstLineStackView.snp.trailing).offset(8.0)
      $0.top.equalTo(firstLineStackView)
    }
    separatorView.snp.makeConstraints {
      $0.top.equalTo(secondLineStackView.snp.bottom).offset(8.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
      $0.height.equalTo(0.5)
    }
    
    contentLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(separatorView.snp.bottom).offset(8.0)
    }
    
    self.backgroundColor = .systemBackground
    self.layer.cornerRadius = 8.0
    self.clipsToBounds = true
  }
}
