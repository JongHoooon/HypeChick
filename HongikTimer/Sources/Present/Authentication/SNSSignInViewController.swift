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
  
  private lazy var emailTextField = TextFieldView(with: "이메일").then {
    $0.textField.becomeFirstResponder()
    $0.textField.delegate = self
  }
  
  private lazy var nicknameTextField = TextFieldView(with: "별명").then {
    $0.textField.delegate = self
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
    emailTextField.textField.rx.text
      .orEmpty
      .map { Reactor.Action.emailInput($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    nicknameTextField.textField.rx.text
      .orEmpty
      .map { Reactor.Action.nicknameInput($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
       
    // MARK: State
    reactor.state.asObservable().map { $0.emailMessage }
      .bind(to: emailTextField.messageLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
    reactor.state.asObservable().map { $0.nickNameMessage }
      .bind(to: nicknameTextField.messageLabel.rx.attributedText)
      .disposed(by: disposeBag)
    
  }
}

// MARK: - TextField

extension SNSSignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(
    _ textField: UITextField
  ) -> Bool {
    if textField == emailTextField.textField {
      nicknameTextField.textField.becomeFirstResponder()
    }
    return true
  }
}

// MARK: - Private

private extension SNSSignInViewController {
  func setupNavigationBar() {
    navigationController?.navigationBar.topItem?.title = ""
    navigationItem.title = "회원가입"
  }
  
  func configureLayout() {
    view.backgroundColor = .systemBackground
    
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      nicknameTextField,
      signUpButton
    ]).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 48.0
      
      [
        emailTextField,
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
    emailTextField.textField.resignFirstResponder()
    nicknameTextField.textField.resignFirstResponder()
    
    guard let email = emailTextField.textField.text, !email.isEmpty else { return }
    guard let username = nicknameTextField.textField.text, !username.isEmpty else { return }
    
    print("DEBUG sns로 회원가입합니다!!!")
      
  }
  
  @objc func loginSuccessHandler() {
    #warning("더미 유저") // 성공후 userdefaul에서 불러오기
    guard let provider = self.reactor?.provider else { return }
    let vc = TabBarViewController(with: TabBarViewReactor(provider, with: User()))
    
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
    navigationController?.popToRootViewController(animated: false)
  }
}
