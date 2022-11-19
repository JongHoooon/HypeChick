//
//  AuthManager.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/15.
//

import Firebase
import UIKit
import Alamofire

enum ApiError: Error {
    case badStatus(_ code: Int)
    case notAccept
    case unknown(_ error: Error?)
    
    var info: String {
        switch self {
        case .badStatus(let code):  return "상태 코드 : \(code)"
        case .notAccept: return "400 에러 입니다"
        case .unknown(let err):     return "알 수 없는 에러입니다 \(String(describing: err?.localizedDescription))"
        }
    }
}

final class AuthService: NSObject {
  
  static let shared = AuthService()
    
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

  ///  이메일 회원 등록 후 로그인
  /// - Parameters:
  ///   - credentials: id, username, password 전달
  ///   - completion:  completion handler
  func registerAndLoginWithEmail(
    credentials: AuthCredentials,
    completion: @escaping (Result<User, ApiError>) -> Void
  ) {
    self.registerWithEmail(credentials: credentials) { result in
      switch result {
      case .success(_):
        self.loginWithEamil(email: credentials.email, password: credentials.password) { loginResult in
          switch loginResult {
          case .success(let user):      completion(.success(user))
          case .failure(let error):     completion(.failure(error))
          }
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /// 이메일 회원 등록
  /// - Parameters:
  ///   - credentials: id, username, password 전달
  ///   - compltetion: completion handler
  func registerWithEmail(
    credentials: AuthCredentials,
    completion: @escaping (Result<MyUser, ApiError>) -> Void
  ) {
    
    let registerRequest = credentials.getRegisterRequest()
    let urlRequest = MembersRouter.emailRegister(registerRequest)
    
    AF.request(urlRequest)
      .responseDecodable(of: UserResponse.self) { dataResponse in
        guard let statusCode = dataResponse.response?.statusCode else { return }
        
        if !(200...299).contains(statusCode) {
          return completion(.failure(ApiError.badStatus(statusCode)))
        }
        
        switch dataResponse.result {
        case .success(let user):
          print("DEBUG Email: \(user)")
          let myUser = MyUser(data: user)
          completion(.success(myUser))
          
        case .failure(let error):
          print("DEBUG 회원가입 실패 error: \(error)")
          completion(.failure(ApiError.unknown(error)))
        }
      }
  }
  
  /// 이메일 로그인
  /// - Parameters:
  ///   - email: 로그인할 이메일
  ///   - password: 패스워드
  ///   - completion: completion handler
  func loginWithEamil(
    email: String,
    password: String,
    completion: @escaping (Result<User, ApiError>) -> Void
  ) {
    let emailLoginRequest = EmailLoginRequest(email: email, password: password)
    let urlRequest = MembersRouter.emailLogin(emailLoginRequest)
    
    AF.request(urlRequest)
      .responseDecodable(of: User.self) { dataResponse in
        guard let statusCode = dataResponse.response?.statusCode else { return }
        
        if !(200...299).contains(statusCode) {
          return completion(.failure(ApiError.badStatus(statusCode)))
        }
        
        switch dataResponse.result {
        case .success(let user):
          print("DEBUG Email: \(user.userInfo.email), UserName: \(user.userInfo.username) 으로 로그인 완료")
          UserDefaultService.shared.setUser(user)
          UserDefaultService.shared.setLoginKind(.email)
          
          completion(.success(user))
        case .failure(let error):
          completion(.failure(ApiError.unknown(error)))
        }
      }
  }
  
//  func loginWithSNS(
//    uid: String,
//    kind: LoginKind,
//    completion: @escaping (Result<User, ApiError>) -> Void
//  ) {
//    let snsLoginRequest = SNSLoginRequest(uid: uid, kind: kind)
//    let urlRequest = MembersRouter.snsLogin(snsLoginRequest)
//
//    AF.request(urlRequest)
//      .responseDecodable(of: User.self) { dataResponse in
//        guard let statusCode = dataResponse.response?.statusCode else { return }
//
//        if !(200...299).contains(statusCode) {
//          return completion(.failure(ApiError.badStatus(statusCode)))
//        }
//
//        switch dataResponse.result {
//
//        }
//      }
//  }
  
  
//  func snsRegister(
//    uid: String,
//    username: String,
//    kind:
//  )
  
}
