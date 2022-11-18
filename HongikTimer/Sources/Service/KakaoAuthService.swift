//
//  KakaoAuthService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/17.
//

import KakaoSDKAuth
import KakaoSDKUser
import UIKit

struct KakaoAuthService {
  
  static let shared = KakaoAuthService()
  
  func signInWithKakao() {
  
    // 카카오톡 설치 여부 확인
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        if let error = error {
          print(error)
        } else {
          print("loginWithKakaoTalk() success.")
          
          _ = oauthToken
          
          UserApi.shared.me { user, error in
            if let error = error {
              print(error)
            } else {
              print("me() success")
              print("User Id : \(user?.id ?? 0)")  // User Id : Optional(2433247323)
            }
          }
          
          AuthNotificationManager
            .shared
            .postNotificationSignInSuccess()
        }
        // do something
        //          let token = oauthToken
      }
    } else {
      UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
        if let error = error {
          print(error)
        } else {
          print("loginWithKakaoAccount() success.")
          
          UserApi.shared.me { user, error in
            if let error = error {
              print(error)
            } else {
              print("me() success")
              print("User Id : \(user?.id ?? 0)")  // User Id : Optional(2433247323)
            }
          }
          
          AuthNotificationManager
            .shared
            .postNotificationSignInSuccess()
          // do something
          _ = oauthToken
        }
      }
    }
  }
  func kakaoLogout() {
    UserApi.shared.logout {(error) in
      if let error = error {
        print(error)
      } else {
        print("logout() success.")
        AuthNotificationManager
          .shared
          .postNotificationSignOutSuccess()
      }
    }
  }
}
