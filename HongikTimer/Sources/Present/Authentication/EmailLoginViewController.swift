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

final class EmailLoginViewController: UIViewController {
  
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
    
    AuthNotificationManager.shared
      .addObserverSignInSuccess(
        with: self,
        completion: #selector(loginSuccessHandler)
      )
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
    emailTextField.textField.resignFirstResponder()
    passwordTextField.textField.resignFirstResponder()
    
    guard let email = emailTextField.textField.text,
          !email.isEmpty,
          let password = passwordTextField.textField.text,
          !password.isEmpty else {
      view.makeToast("이메일 / 비밀번호를 확인하세요", position: .top)
      return
    }
    
    AuthService.shared.logInWithEmail(
      email: email,
      password: password) { [weak self] authResult, error in
        guard authResult != nil, error == nil else {
          print("DEBUG tapLoginButton error: \(String(describing: error))")
          self?.view.makeToast("이메일 / 비밀번호를 확인하세요")
          return }
        
//        AuthNotificationManager.shared.postNotificationSignInSuccess()
      }
  }
  
  @objc func loginSuccessHandler() {
    
#warning("더미 유저")
    let user: User = ServiceProvider().userDefaultService.getUser()?.userInfo ?? User()
    
    let vc = TabBarViewController(with: TabBarViewReactor(ServiceProvider(), with: user))
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
    navigationController?.popToRootViewController(animated: false)
  }
}

// TODO: 인디케이터 추가
