//
//  AuthManager.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/15.
//

import Firebase
import UIKit
import Alamofire

final class AuthService: NSObject {
  
  static let shared = AuthService()
  
//  var userVM = UserViewModel()
  
  func logOutWithFirebase(completion: (Bool) -> Void) {
    do {
      try Auth.auth().signOut()
      completion(true)
      return
      
    } catch {
      print("DEBUG log out with firebase error is \(error)")
      completion(false)
      return
    }
  }
}

// MARK: - Email

extension AuthService {
  
  func signUpWithEmail(
    credentials: AuthCredentials,
    completion: ((AuthDataResult?, Error?) -> Void)?,
    completionAF: @escaping ((AFError?) -> Void)
  ) {
    let email = credentials.email
    let password = credentials.password
    
    // firebase 사용
    Auth.auth().createUser(
      withEmail: email,
      password: password,
      completion: completion
    )
    
    AF.request(APIRouter.emailSignIn(
      email: credentials.email,
      username: credentials.username,
      password: credentials.password
    )).responseDecodable(of: User.self) { [weak self] response in
      guard let self = self else { return }
      
      switch response.result {
      case .success(let user):
        
        print("DEBUG Email: \(user.email), Username: \(user.username) 으로 회원가입 성공")
        
        self.logInAfterSignIn(email: user.email, password: credentials.password)
        
      case .failure(let error):
        
        print("DEBUG 회원가입 post 실패 error: \(error)")
        
        #warning("dummy current user")
    
        self.logInAfterSignIn(email: credentials.email, password: credentials.password)
        
        completionAF(error)
        
      }
    }
  }
  
  func logInWithEmail(
    email: String,
    password: String,
    completion: @escaping((AuthDataResult?, Error?) -> Void)
  ) {
    Auth.auth().signIn(
      withEmail: email,
      password: password,
      completion: completion
    )

    AF.request(APIRouter.emailLogin(email: email, password: password))
      .responseDecodable(of: EmailUser.self) { response in
        switch response.result {
        case .success(let emailUser):
          
          UserDefaultService.shared.setUser(emailUser)
          
          print("DEBUG email: \(emailUser.userInfo.email), username: \(emailUser.userInfo.username) 으로 이메일 로그인 완료")
          
          AuthNotificationManager.shared.postNotificationSignInSuccess()
        case .failure(let error):
          
          print("DEBUG 이메일로 로그인 실패")
          
          print("DEBUG AF 더미 USER 생성")
          let user = EmailUser()
          UserDefaultService.shared.setUser(user)
          
          AuthNotificationManager.shared.postNotificationSignInSuccess()
        }
      }
  }
  
  func logInAfterSignIn(
    email: String,
    password: String) {
      AF.request(APIRouter.emailLogin(email: email, password: password))
        .responseDecodable(of: EmailUser.self) { response in
          switch response.result {
          case .success(let emailUser):
            
            UserDefaultService.shared.setUser(emailUser)
            print("DEBUG email: \(emailUser.userInfo.email), username: \(emailUser.userInfo.username) 으로 이메일 회원가입후 로그인 완료")
            
            AuthNotificationManager.shared.postNotificationSignInSuccess()

          case .failure(let error):
            
            print(error)
            print("DEBUG email 회원가입후 이메일로 로그인 실패")

            print("DEBUG AF 더미 USER 생성")
            let user = EmailUser()
            UserDefaultService.shared.setUser(user)
            
            AuthNotificationManager.shared.postNotificationSignInSuccess()
          }
        }
    }
}
