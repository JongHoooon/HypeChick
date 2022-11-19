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
//    case serverError(_ error : ErrorResponse?)
    
    var info: String {
        switch self {
        case .badStatus(let code):  return "상태 코드 : \(code)"
        case .notAccept: return "400 에러 입니다 정말 싫다"
//        case .serverError(let err): return err?.message ?? ""
        case .unknown(let err):     return "알 수 없는 에러입니다 \(String(describing: err?.localizedDescription))"
        }
    }
}

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

  // 회원가입 -> 로그인
//    self.logInAfterSignIn(email: myUser.email, password: credentials.password)
  func registerAndLoginWithEmail(
      credentials: AuthCredentials,
      completion: @escaping (Result<User, ApiError>) -> Void
  ) {
      self.registerWithEmail(credentials: credentials, completion: { result in
          switch result {
          case .success(_):
              self.loginWithEmail(credentials: credentials, completion: { loginResult in
                  switch loginResult {
                  case .success(let user):
                      completion(.success(user))
                  case .failure(let failure):
                      completion(.failure(failure))
                  }
              })
          case .failure(let failure):
              completion(.failure(failure))
          }
      })
  }
  
  // 회원가입
  func registerWithEmail(
    credentials: AuthCredentials,
     completion: @escaping (Result<MyUser, ApiError>) -> Void
  ) {
      let registerRequest = credentials.getRegisterRequest()
      
      let urlRequest = MembersRouter.register(registerRequest)
    
      AF.request(urlRequest)
          .responseDecodable(of: UserResponse.self) { [weak self] response in
            guard let self = self,
                  let statusCode = response.response?.statusCode else {
                return
            }
              switch statusCode {
              case 400:
                  return completion(.failure(ApiError.notAccept))
              default:
                  print("default")
              }
              
              // 허용하지 않는 코드 입니다
              if !(200...299).contains(statusCode) {
                  return completion(.failure(ApiError.badStatus(statusCode)))
              }
              
            switch response.result {
            case .success(let user):

              print("DEBUG Email: \(user.email), Username: \(user.username) 으로 회원가입 성공")

              let myUser = MyUser(data: user)
              
                completion(.success(myUser))
                
            case .failure(let error):

              print("DEBUG 회원가입 post 실패 error: \(error)")

              #warning("dummy current user")
                completion(.failure(ApiError.unknown(error)))
            }
          }
  }
  
  // 로그인
  func loginWithEmail(
    credentials: AuthCredentials,
     completion: @escaping (Result<User, ApiError>) -> Void
  ) {
      let emailLoginRequest = credentials.getEmailLoginRequest()
      
      let urlRequest = MembersRouter.emailLogin(emailLoginRequest)
    
      AF.request(urlRequest)
          .responseDecodable(of: EmailUser.self) { [weak self] response in
            guard let self = self,
                  let statusCode = response.response?.statusCode else {
                return
            }
              switch statusCode {
              case 400:
                  return completion(.failure(ApiError.notAccept))
              default:
                  print("default")
              }
              
              // 허용하지 않는 코드 입니다
              if !(200...299).contains(statusCode) {
                  return completion(.failure(ApiError.badStatus(statusCode)))
              }
              
            switch response.result {
            case .success(let emailUser):

                print("DEBUG Email: \(emailUser.userInfo.email), Username: \(emailUser.userInfo.username) 으로 회원가입 성공")

              completion(.success(emailUser.userInfo))
                
            case .failure(let error):

              print("DEBUG 회원가입 post 실패 error: \(error)")

              #warning("dummy current user")
                completion(.failure(ApiError.unknown(error)))
            }
          }
  }
}
