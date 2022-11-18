//
//  RegisterViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/14.
//

import AuthenticationServices
import Firebase
import GoogleSignIn
import SnapKit
import Toast_Swift
import Then
import UIKit
import NaverThirdPartyLogin
import Alamofire

final class RegisterViewController: BaseViewController {
  
  // MARK: - Property
    
  let reactor: RegisterViewReactor
  
  var window: UIWindow?
  private var currentNonce: String?
  
  private lazy var naverAuthService = NaverAuthService(delegate: self)
  
  private lazy var logoImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.image = UIImage(named: "chick1")
  }
  
  private lazy var appleLoginButton = UIButton(configuration: snsLoginConfig).then {
    var title = AttributedString("Apple로 계속하기")
    title.font = .systemFont(ofSize: 19)
    title.foregroundColor = .systemBackground
    $0.configuration?.attributedTitle = title
    var logo = UIImage(systemName: "applelogo")?.withTintColor(
      .systemBackground,
      renderingMode: .alwaysOriginal
    )
    $0.configuration?.image = logo
    $0.addTarget(self, action: #selector(tapAppleLogin), for: .touchUpInside)
  }
  
  private lazy var googleLoginButton = UIButton(configuration: snsLoginConfig).then {
    var title = AttributedString("Google로 계속하기")
    title.font = .systemFont(ofSize: 19)
    $0.configuration?.baseForegroundColor = .black
    $0.configuration?.attributedTitle = title
    $0.configuration?.baseBackgroundColor = .white
    var logo = UIImage(named: "googleLogo")
    $0.configuration?.image = logo
    $0.configuration?.background.strokeColor = .separator
    $0.configuration?.background.strokeWidth = 0.5
    $0.addTarget(self, action: #selector(tapGoogleLogin), for: .touchUpInside)
  }
  
  private lazy var kakaoLoginButton = UIButton(configuration: snsLoginConfig).then {
    var title = AttributedString("Kakao로 계속하기")
    title.font = .systemFont(ofSize: 19)
    $0.configuration?.baseForegroundColor = .Social.kakaoBrown
    $0.configuration?.attributedTitle = title
    $0.configuration?.baseBackgroundColor = .Social.kakaoYellow
    var logo = UIImage(named: "kakaoLogo")
    $0.configuration?.image = logo
    $0.addTarget(self, action: #selector(tapKakaoLogin), for: .touchUpInside)
  }
  
  private lazy var naverLoginButton = UIButton(configuration: snsLoginConfig).then {
    var title = AttributedString("Naver로 계속하기")
    title.font = .systemFont(ofSize: 19)
    $0.configuration?.baseForegroundColor = .white
    $0.configuration?.attributedTitle = title
    $0.configuration?.baseBackgroundColor = .Social.naverGreen
    var logo = UIImage(named: "naverLogo")
    $0.configuration?.image = logo
    $0.addTarget(self, action: #selector(tapNaverLogin), for: .touchUpInside)
  }
  
  private lazy var registerButton = UIButton(configuration: labelConfig).then {
    $0.setTitle("계정 만들기", for: .normal)
    $0.setTitleColor(.systemBackground, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
    $0.addTarget(
      self,
      action: #selector(tapRegisterButton),
      for: .touchUpInside
    )
  }
  
  private lazy var separatorView = SeparatorView()
  
  private lazy var moveToLoginLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .medium)
    $0.textColor = .secondaryLabel
    $0.text = "이미 계정이 있으세요?"
  }
  
  private lazy var moveToLoginButton = UIButton().then {
    $0.setTitle("로그인하기", for: .normal)
    $0.setTitleColor(.link, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
    $0.addTarget(
      self,
      action: #selector(tapMoveToLoginButton),
      for: .touchUpInside
    )
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    
    AuthNotificationManager
      .shared
      .addObserverSignInSuccess(
        with: self,
        completion: #selector(loginSuccessHandler)
      )
    
    AuthNotificationManager
      .shared
      .addObserverSnsSignInNeed(
        with: self,
        completion: #selector(snsSignInHandler)
      )
    //        try? Auth.auth().signOut()
    //        KakaoAuthService.shared.kakaoLogout()
    //        naverAuthService.shared?.requestDeleteToken()
  }
  
  // MARK: - Init
  
  init(with reactor: RegisterViewReactor) {
  
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate

extension RegisterViewController: NaverThirdPartyLoginConnectionDelegate {
  
  // 로그인 성공
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("DEBUG 네이버 로그인 성공")
    
    self.naverLoginGetInfo()
    
//    AuthNotificationManager.shared.postNotificationSignInSuccess()
    AuthNotificationManager.shared.postNotificationSnsSignInNeed()
    
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    //        print("DEBUG 네이버 토큰\(shared?.accessToken)")
  }
  
  // 로그아웃 (토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    print("DEBUG 네이버 로그아웃")
    
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("DEBUG 에러 = \(error.localizedDescription)")
  }
  
  func naverLoginGetInfo() {
      
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    
    if !isValidAccessToken {
      print("DEBUG naver login access token이 없습니다")
      return
    }
    
    guard let tokenType = loginInstance?.tokenType else {
      print("DEBUG naver login token type이 없음.")
      return
    }
    guard let accessToken = loginInstance?.accessToken else {
      print("DEBUG naver login accessToken이 없음.")
      return
    }
    
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    
    let authorization = "\(tokenType) \(accessToken)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    
    req.responseJSON { response in
      guard let result = response.value as? [String: Any] else { return }
      guard let object = result["response"] as? [String: Any] else { return }
      guard let id = object["id"] as? String else { return }
      
      print("DEBUG naver login id: \(id)")
    }
  }
}

// MARK: - Method

extension RegisterViewController {
  private func setupLayout() {
    view.backgroundColor = .systemBackground
    let snsStackView = UIStackView().then { sv in
      sv.axis = .vertical
      sv.distribution = .equalSpacing
      sv.spacing = 16.0
      [
        appleLoginButton,
        googleLoginButton,
        kakaoLoginButton,
        naverLoginButton
      ].forEach {
        sv.addArrangedSubview($0)
        $0.snp.makeConstraints {
          $0.height.equalTo(snsButtonHeight)
        }
      }
    }
    let stackView = UIStackView(
      arrangedSubviews: [moveToLoginLabel, moveToLoginButton]
    ).then {
      $0.axis = .horizontal
      $0.distribution = .fill
      $0.spacing = 4.0
    }
    [
      logoImageView,
      snsStackView,
      separatorView,
      registerButton,
      stackView
    ].forEach { view.addSubview($0) }
    
    logoImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(100.0)
      $0.height.width.equalTo(150.0)
    }
    
    snsStackView.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(48.0)
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
    }
    
    separatorView.snp.makeConstraints {
      $0.top.equalTo(snsStackView.snp.bottom).offset(16.0)
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
      $0.height.equalTo(24.0)
    }
    
    registerButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(authDefaultInset)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(52.0)
      $0.top.equalTo(separatorView.snp.bottom).offset(4.0)
    }
    
    stackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(authDefaultInset)
      $0.bottom.equalToSuperview().inset(36.0)
      $0.height.equalTo(16.0)
    }
  }
  
  // MARK: - Selector
  
  @objc func tapAppleLogin() {
    guard let window = view.window else { return }
    
    AppleAuthService.shared.signInWithApple(window: window)
  }
  
  @objc func tapGoogleLogin() {
    GoogleAuthService.shared.signInWithGoogle(with: self)
  }
  
  @objc func tapKakaoLogin() {
    KakaoAuthService.shared.signInWithKakao()
  }
  
  @objc func tapNaverLogin() {
    naverAuthService.shared?.requestThirdPartyLogin()
  }
  
  @objc func tapRegisterButton() {
    let vc = EmailSignUpViewController(with: EmailSignUpReactor(provider: self.reactor.provider))
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func tapMoveToLoginButton() {
    let vc = UINavigationController(
      rootViewController: EmailLoginViewController()
    )
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
  }
  
  @objc func loginSuccessHandler() {
    #warning("더미 유저") // 성공후 userdefaul에서 불러오기
    let vc = TabBarViewController(with: TabBarViewReactor(reactor.provider, with: User()))
    
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true)
    navigationController?.popToRootViewController(animated: false)
  }
  
  @objc func snsSignInHandler() {
    let vc = SNSSignInViewController(
      with: SNSSignInViewReactor(provider: self.reactor.provider)
    )
    navigationController?.pushViewController(vc, animated: true)
  }
}
