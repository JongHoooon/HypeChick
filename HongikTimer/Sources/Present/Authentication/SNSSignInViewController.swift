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
import NaverThirdPartyLogin

final class SNSSignInViewController: BaseViewController, View {
  
  // MARK: - Property
  
  private lazy var naverAuthService = NaverAuthService(delegate: self)
  
  private lazy var nicknameTextField = TextFieldView(with: "별명").then {
    $0.becomeFirstResponder()
  }
  
  private lazy var signInButton = UIButton(configuration: labelConfig).then {
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
    
//    signInButton.rx.tap
//      .map { Reactor.Action.tapSignIn }
//      .bind(to: reactor.action)
//      .disposed(by: self.disposeBag)
    
    // MARK: State
    
    reactor.state.asObservable().map { $0.validatedNickname }
      .bind(to: nicknameTextField.messageLabel.rx.inputValidate)
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map { $0.validatedNickname }
      .bind(to: signInButton.rx.buttonValidate)
      .disposed(by: self.disposeBag)
  }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate

extension SNSSignInViewController: NaverThirdPartyLoginConnectionDelegate {
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    
  }
  
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    
  }
  
  func oauth20ConnectionDidFinishDeleteToken() {
    
  }
  
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    
  }
  
  
}

// MARK: - Private

private extension SNSSignInViewController {
  func setupNavigationBar() {

    let backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(tapBackButton))
    self.navigationItem.leftBarButtonItem = backBarButtonItem

//    navigationController?.navigationBar.topItem?.title = ""
    navigationItem.title = "회원가입"
  }
  
  func configureLayout() {
    view.backgroundColor = .systemBackground
     
    let stackView = UIStackView(arrangedSubviews: [
      nicknameTextField,
      signInButton
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
      $0.top.equalToSuperview().inset(148.0)
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
    }
  }
  
  // MARK: - Selector
  
  @objc func tapsignUpButton() {
    
    APIClient.request(
      UserInfo.self,
      router: MembersRouter.snsRegister(SNSRegisterRequest(uid: reactor?.uid ?? "",
                                                           username: reactor?.currentState.username ?? "",
                                                           kind: reactor?.kind ?? .email))
    ) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let userInfo):
        
        // 회원가입 완료후 로그인
        APIClient.request(
          User.self,
          router: MembersRouter.snsLogin(SNSLoginRequest(uid: userInfo.email ?? "",
                                                         kind: self.reactor?.kind ?? .email)
          )) { result in
         
            switch result {
              
            case .success(let user):
              print("DEBUG \(self.reactor?.kind) \(user.userInfo.id) 로그인 완료")
              self.reactor?.provider.userDefaultService.setUser(user)
              self.reactor?.provider.userDefaultService.setLoginKind(self.reactor?.kind ?? .email)
              
              guard let provider = self.reactor?.provider else { return }
              let vc = TabBarViewController(with: TabBarViewReactor(provider, with: user.userInfo))
              
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true)
              self.navigationController?.popToRootViewController(animated: false)
              
            case .failure(let err):
              APIClient.handleError(err)
              print("회원가입 후 로그인 실패")
            }
          }
      case .failure(let error):
        APIClient.handleError(.unknown(error))
        print("DEBUG SNS 회원가입 실패")
      }
    }
  }
  
  /// back button 클릭시 sns인증 상태 초기화
  @objc func tapBackButton() {
    switch reactor?.kind {
    case .kakao:
      KakaoAuthService.shared.kakaoLogout()
      print("DEBUG kakao 인증 초기화")
    case .naver:
      self.naverAuthService.shared?.requestDeleteToken()
      print("DEBUG naver 인증 초기화")
    default:
      try? Auth.auth().signOut()
      print("DEBUG apple or google 인증 초기화")
    }
    self.navigationController?.popViewController(animated: true)
  }
}
