//
//  EmailLoginViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/14.
//

import SnapKit
import Toast_Swift
import Then
import UIKit
import ReactorKit

final class EmailLoginViewController: BaseViewController, View {
  
  private var labelConfig = ButtonConfig(buttonConfig: .label).getConfig()
  
  private lazy var emailTextField = TextFieldView(with: "이메일").then {
    $0.textField.becomeFirstResponder()
    $0.textField.delegate = self
  }
  
  private lazy var passwordTextField = TextFieldView(with: "비밀번호").then {
    $0.textField.returnKeyType = .done
    $0.textField.isSecureTextEntry = true
    $0.textField.delegate = self
  }
  
  private lazy var loginButton = UIButton(configuration: labelConfig).then {
    $0.setTitle(
      "로그인",
      for: .normal
    )
    $0.setTitleColor(
      .systemBackground,
      for: .normal
    )
    $0.titleLabel?.font = .systemFont(
      ofSize: 16.0,
      weight: .bold
    )
    $0.addTarget(
      self,
      action: #selector(tapLoginButton),
      for: .touchUpInside
    )
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    setupNavigationBar()
    setupLayout()
  }
  
  // MARK: - Init
  init(_ reactor: EamilLoginViewReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: EamilLoginViewReactor) {
    
    // action
    emailTextField.textField.rx.text
      .orEmpty
      .map(Reactor.Action.emailInput)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    passwordTextField.textField.rx.text
      .orEmpty
      .map(Reactor.Action.passwordInput)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // state
    let email = reactor.state.asObservable().map { $0.email }
    let password = reactor.state.asObservable().map { $0.password }
    
    Observable.combineLatest(email, password)
      .flatMap { email, password -> Observable<Bool> in
        if !email.isEmpty && !password.isEmpty {
          return Observable.just(true)
        } else {
          return Observable.just(false)
        }
      }
      .bind(to: self.loginButton.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }
}

// MARK: - TextField

extension EmailLoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField.textField {
      passwordTextField.textField.becomeFirstResponder()
    } else if textField == passwordTextField.textField {
      tapLoginButton()
    }
    return true
  }
}

// MARK: - Private

private extension EmailLoginViewController {
  
  func setupNavigationBar() {
    navigationItem.title = "Email 로그인"
    
    lazy var leftBarButton = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(tapLeftBarButton)
    )
    navigationItem.leftBarButtonItem = leftBarButton
  }
  
  func setupLayout() {
    
    view.backgroundColor = .systemBackground
    [
      emailTextField,
      passwordTextField,
      loginButton
    ].forEach { view.addSubview($0) }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalToSuperview().inset(200.0)
      $0.leading.trailing.equalToSuperview().offset(authDefaultInset)
      $0.height.equalTo(textFieldHeight)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(48.0)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(textFieldHeight)
    }
    
    loginButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(48.0)
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
    }
  }
  
  // MARK: - Selector
  
  @objc func tapLeftBarButton() {
    dismiss(animated: true)
  }
  
  @objc func tapLoginButton() {
    
    self.view.makeToastActivity(.center)
    
    emailTextField.textField.resignFirstResponder()
    passwordTextField.textField.resignFirstResponder()
    
    self.reactor?.provider.authService.loginWithEamil(
      email: reactor?.currentState.email ?? "",
      password: reactor?.currentState.password ?? "",
      completion: { [weak self] result in
        guard let self = self else { return }
        
        switch result {
        case .success(let user):
          
          self.view.hideToastActivity()
          let userInfo = user.userInfo
          let provider = self.reactor?.provider
          let vc = TabBarViewController(with: TabBarViewReactor(provider!, with: userInfo))
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true)
          
        case .failure(let error):
          self.view.hideToastActivity()
          APIClient.handleError(error)
          
          self.view.makeToast("아이디 / 비밀번호를 확인해주세요.", position: .top)
        }
    })
  }
}
