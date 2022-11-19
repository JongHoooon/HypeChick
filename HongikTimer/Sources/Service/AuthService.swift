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
  
  
  
  
  /*
  
  
  
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
    
    /*
    let url = "http://localhost:8080/api/v1/members"
    let param: Parameters = [
      "username": credentials.username,
      "email": credentials.email,
      "password": credentials.password
    ]
    let headers: HTTPHeaders = [
      "Accept": "application/json"
    ]
    
    AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: User.self) { [weak self] response in
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
     */
     
    AF.request(APIRouter.emailSignIn(
      email: credentials.email,
      username: credentials.username,
      password: credentials.password
    ))
    .responseDecodable(of: User.self) { [weak self] response in
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
      
      let url = "http://localhost:8080/api/v1/login"
      let param: Parameters = [
        "email": email,
        "password": password
      ]
      let headers: HTTPHeaders = [
        "Accept": "application/json"
      ]
      
      AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: EmailUser.self) { response in
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
      
      
      /*
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
      */
      
      
    }
   
   
   */
}
