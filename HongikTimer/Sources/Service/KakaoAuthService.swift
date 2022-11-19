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
          print("DEBUG loginWithKakaoTalk() success.")
          
          _ = oauthToken
          
          UserApi.shared.me { user, error in
            if let error = error {
              print(error)
            } else {
              let uid = String(user?.id ?? 0)
              print("DEBUG kakao User Id : \(uid)")
              
              APIClient.request(
                User.self,
                router: MembersRouter.snsLogin(SNSLoginRequest(uid: uid,
                                                               kind: .kakao)
                )) { result in
                  switch result {
                  case .success(let user):
                    print("DEBUG kakao \(user.userInfo.id) 로그인 완료")
                    UserDefaultService.shared.setUser(user)
                    UserDefaultService.shared.setLoginKind(.kakao)
                    
                    AuthNotificationManager
                      .shared
                      .postNotificationSignInSuccess()
                    
                  case .failure(let err):
                    APIClient.handleError(err)
                    print("DEBUG 존재하지 않는 회원입니다. SNS회원 가입으로 이동")
                    AuthNotificationManager.shared.postNotificationSnsSignInNeed(uid: uid, kind: .kakao)
                  }
                }
            }
          }
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
          
          _ = oauthToken
          
          UserApi.shared.me { user, error in
            if let error = error {
              print(error)
            } else {
              let uid = String(user?.id ?? 0)
              print("DEBUG kakao User Id : \(uid)")
              
              APIClient.request(
                User.self,
                router: MembersRouter.snsLogin(SNSLoginRequest(uid: uid,
                                                               kind: .kakao)
                )) { result in
                  switch result {
                  case .success(let user):
                    print("DEBUG kakao \(user.userInfo.id) 로그인 완료")
                    UserDefaultService.shared.setUser(user)
                    UserDefaultService.shared.setLoginKind(.kakao)
                    
                    AuthNotificationManager
                      .shared
                      .postNotificationSignInSuccess()
                    
                  case .failure(let err):
                    APIClient.handleError(err)
                    print("DEBUG 존재하지 않는 회원입니다. SNS회원 가입으로 이동")
                    AuthNotificationManager.shared.postNotificationSnsSignInNeed(uid: uid, kind: .kakao)
                  }
                }
            }
          }
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
