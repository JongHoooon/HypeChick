//
//  SNSSignInViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Firebase
import SnapKit
import Then
import UIKit
import CloudKit
import ReactorKit
import RxSwift
import RxCocoa

final class SNSSignInViewController: BaseViewController, View {
  
  // MARK: - Property
  
  private lazy var nicknameTextField = TextFieldView(with: "별명").then {
    $0.becomeFirstResponder()
  }
  
  private lazy var signUpButton = UIButton(configuration: labelConfig).then {
    $0.setTitle("회원가입", for: .normal)
    $0.setTitleColor(.systemBackground, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
    $0.addTarget(
      self,
      action: #selector(tapsignUpButton),
      for: .touchUpInside
    )
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    setupNavigationBar()
    configureLayout()
    
    let tapBackground = UITapGestureRecognizer()
    tapBackground.rx.event
        .subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
        .disposed(by: disposeBag)
    view.addGestureRecognizer(tapBackground)
    
    AuthNotificationManager
      .shared
      .addObserverSignInSuccess(
        with: self,
        completion: #selector(loginSuccessHandler)
      )
  }
  
  // MARK: - Init
  
  init(with reactor: SNSSignInViewReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - bind

extension SNSSignInViewController {
  func bind(reactor: SNSSignInViewReactor) {
    
    // MARK: Action
    
    nicknameTextField.textField.rx.text
      .orEmpty
      .map { Reactor.Action.nicknameInput($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
       
    // MARK: State
    
    reactor.state.asObservable().map { $0.nickNameMessage }
      .bind(to: nicknameTextField.messageLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
  }
}

// MARK: - TextField

// MARK: - Private

private extension SNSSignInViewController {
  func setupNavigationBar() {
    navigationController?.navigationBar.topItem?.title = ""
    navigationItem.title = "회원가입"
  }
  
  func configureLayout() {
    view.backgroundColor = .systemBackground
    
    let stackView = UIStackView(arrangedSubviews: [
      nicknameTextField,
      signUpButton
    ]).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 96.0
      
      [
        nicknameTextField
      ].forEach { $0.snp.makeConstraints {
        $0.height.equalTo(textFieldHeight)
      }}
    }
    
    [
      stackView
    ].forEach { view.addSubview($0) }
    
    stackView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100.0)
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
    }
  }
  
  // MARK: - Selector
  
  @objc func tapsignUpButton() {
    nicknameTextField.textField.resignFirstResponder()
    
    guard let username = nicknameTextField.textField.text, !username.isEmpty else { return }
    
    print("DEBUG sns로 회원가입합니다!!!")
      
  }
  
  @objc func loginSuccessHandler() {
    #warning("더미 유저") // 성공후 userdefaul에서 불러오기
    guard let provider = self.reactor?.provider else { return }
    let vc = TabBarViewController(with: TabBarViewReactor(provider, with: UserInfo()))
    
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
    navigationController?.popToRootViewController(animated: false)
  }
}
