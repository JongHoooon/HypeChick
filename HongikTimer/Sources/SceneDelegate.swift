//
//  SceneDelegate.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import KakaoSDKAuth
import NaverThirdPartyLogin
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Property
  var window: UIWindow?
  var provider: ServiceProviderType = ServiceProvider()
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.backgroundColor = .systemBackground
    UINavigationBar.appearance().tintColor = .barTint
    
    UITabBar.appearance().tintColor = .barTint

    window?.rootViewController = isCurrentUser()
    window?.makeKeyAndVisible()
    
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if AuthApi.isKakaoTalkLoginUrl(url) {
        _ = AuthController.handleOpenUrl(url: url)
      } else {
        // 네이버 로그인 화면이 새로 등장 -> 토큰을 요청하는 코드
        NaverThirdPartyLoginConnection
          .getSharedInstance()?
          .receiveAccessToken(URLContexts.first?.url)
      }
    }
  }
  
  func isCurrentUser() -> UIViewController {
    if provider.userDefaultService.getUser() == nil {
      let vc = RegisterViewController(with: RegisterViewReactor(self.provider))
      return UINavigationController(rootViewController: vc)
    } else {
      let user = provider.userDefaultService.getUser()?.userInfo
      return TabBarViewController(with: TabBarViewReactor(self.provider, with: user!))
    }
  }
}
