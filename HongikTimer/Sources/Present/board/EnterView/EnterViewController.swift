//
//  EnterViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import Toast_Swift

final class EnterViewController: BaseViewController, View {
  
  // MARK: - Property
  
  private lazy var  titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 24.0, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 0
  }
  
  lazy var chiefLabel = UILabel()
  
  lazy var startDayLabel = UILabel()
  
  lazy var totalTimeLabel = UILabel()
  
  lazy var memberLabel = UILabel()
  
  private lazy var separatorView = UIView().then {
    $0.backgroundColor = .quaternaryLabel
  }
  
  private lazy var separatorLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12.0, weight: .regular)
    $0.text = "그룹소개"
    $0.textColor = .secondaryLabel
  }
  
  private lazy var contentLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 0
    
  }
  
  private lazy var enterButton = UIButton().then {
    $0.setTitle("입장하기", for: .normal)
    $0.backgroundColor = .label
    $0.setTitleColor(.systemBackground, for: .normal)
    $0.layer.cornerRadius = 8.0
    $0.addTarget(self, action: #selector(tapEnterButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    configureNavigateion()
    
  }
  
  // MARK: - Initialize
  init(reactor: EnterViewReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Binding
  func bind(reactor: EnterViewReactor) {
    
    guard let boardPost = self.reactor?.currentState.boardPost else { return }
    self.titleLabel.text = boardPost.title
    self.memberLabel.attributedText = makeLabel("인원",
                                                content: "\(boardPost.memberCount)/\(boardPost.maxMemberCount)명")
    self.chiefLabel.attributedText = makeLabel("그룹장",
                                               content: boardPost.chief)
    self.startDayLabel.attributedText = makeLabel("시작일",
                                                  content: boardPost.startDay)
    self.totalTimeLabel.attributedText = makeLabel("총 시간",
                                                   content: "\(boardPost.totalTime%3600)시간")
    self.contentLabel.text = boardPost.content
  }
  
}

// MARK: - Method

private extension EnterViewController {
  
  func configureNavigateion() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: self,
      action: #selector(tapLeftbarButton)
    )
  }
  
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
    
    view.backgroundColor = .systemBackground
    
    [
      titleLabel,
      firstLineStackView,
      secondLineStackView,
      separatorView,
      separatorLabel,
      contentLabel,
      enterButton
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16.0)
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
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
    
    separatorLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.top.equalTo(separatorView.snp.bottom).offset(16.0)
    }
    
    contentLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(titleLabel)
      $0.top.equalTo(separatorLabel.snp.bottom).offset(16.0)
    }
    
    enterButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
    }
    
  }
  
  // MARK: - Selector
  
  @objc func tapLeftbarButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func tapEnterButton() {
    print("입장하기")
    
    let alertController = UIAlertController(title: "", message: "가입이 완료됐습니다.", preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }
  
    alertController.addAction(action)
    present(alertController, animated: true)
  }
}
