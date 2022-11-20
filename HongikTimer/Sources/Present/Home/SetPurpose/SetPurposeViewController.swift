//
//  SetPurposeViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit
import ReactorKit

class SetPurposeViewController: BaseViewController, View {
  
  var textCompletion: ((String) -> Void)?
  
  private let barButtonTintColor = UIColor.white
  
  private lazy var textField = UITextField().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 16.0, weight: .medium)
    $0.textAlignment = .center
    $0.becomeFirstResponder()
    $0.addAction(UIAction(handler: textHandler), for: .editingChanged)
  }
  
  private lazy var countLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 12.0, weight: .light)
    $0.text = "0 / 20"
  }
  
  private lazy var leftBarButton = UIBarButtonItem(
    title: "취소",
    style: .plain,
    target: self,
    action: #selector(tapLeftBarButton)
  ).then {
    $0.tintColor = barButtonTintColor
  }
  
  private lazy var rightBarButton = UIBarButtonItem(
    title: "확인",
    style: .plain,
    target: self,
    action: #selector(tapRightBarButton)
  ).then {
    $0.tintColor = barButtonTintColor
    $0.isEnabled = false
  }
  
  private lazy var separatorView = UIView().then {
    $0.backgroundColor = .separator
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black.withAlphaComponent(0.9)
    setNavigationBar()
    setupLayout()
  }
  
  // MARK: - Init
  
  init(reactor: SetPurposeViewReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: SetPurposeViewReactor) {
    
    // action
    textField.rx.text
      .orEmpty
      .skip(1)
      .map { Reactor.Action.countText(text: $0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // state
    reactor.state.asObservable().map { $0.count }
      .subscribe(onNext: { [weak self] count in
        guard let self = self else { return }
        
        if count <= 20 {
          
          let countText = String(count) + " / 20"
          self.countLabel.text = countText
        } else {
          self.textField.deleteBackward()
        }
      })
      .disposed(by: self.disposeBag)
    
  }
}

// MARK: - Private

private extension SetPurposeViewController {
  
  func setNavigationBar() {
    navigationItem.leftBarButtonItem = leftBarButton
    navigationItem.rightBarButtonItem = rightBarButton
    
  }
  
  func setupLayout() {
    [
      textField,
      separatorView,
      countLabel
    ].forEach { view.addSubview($0) }
    
    textField.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.keyboardLayoutGuide).offset(-218)
    }
    
    separatorView.snp.makeConstraints {
      $0.height.equalTo(1.0)
      $0.leading.trailing.equalToSuperview().inset(16.0)
      $0.top.equalTo(textField.snp.bottom)
    }
    
    countLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(separatorView.snp.bottom).offset(4.0)
    }
  }
  
  func textHandler(_: UIAction) {
    if self.textField.text?.isEmpty == true {
      self.rightBarButton.isEnabled = false
    } else {
      self.rightBarButton.isEnabled = true
    }
  }
  
  // MARK: - Selector
  
  @objc func tapLeftBarButton() {
    dismiss(animated: true)
  }
  
  @objc func tapRightBarButton() {
    guard let text = textField.text else { return }
    textCompletion?(text)
    dismiss(animated: true)
    
    // TODO: api 연결
  }
}
