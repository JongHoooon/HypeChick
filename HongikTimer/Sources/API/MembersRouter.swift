//
//  MembersRouter.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation
import Alamofire

/// 회원
enum MembersRouter: URLRequestConvertible {
  
  // MARK: - Property
  var baseURL: URL {
    return URL(string: APIClient.BASE_URL)!
  }
  
  // MARK: - Cases
  
  /// 회원등록
  case emailRegister(_ request: RegisterRequest)
  
  /// 이메일 로그인
  case emailLogin(_ request: EmailLoginRequest)
  
  /// SNS 회원가입
  case snsRegister(_ request: SNSRegisterRequest)
  
  /// SNS 로그인
  case snsLogin(_ request: SNSLoginRequest)
  
  
  // MARK: - Path
  
  var path: String {
    switch self {
    case .emailRegister:              return "v1/members"
    case .emailLogin:                 return "v1/login"
    case .snsRegister(let request):   return "v1/members/\(request.kind)"
    case .snsLogin(let request):      return "v1/socialLogin/\(request.kind.rawValue)"
    }
  }
  
  // MARK: - Method
  
  var method: HTTPMethod {
    switch self {
    default: return .post
    }
  }
  
  // MARK: - Parameters
  
  var parameters: Parameters? {
    switch self {
    case .emailRegister(let request):     return request.parameters
    case .emailLogin(let request):        return request.parameters
    case .snsRegister(let request):       return request.parameters
    case .snsLogin(let request):          return request.parameters
    }
  }
  
  // MARK: - URL Request
  func asURLRequest() throws -> URLRequest {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    
    urlRequest.method = self.method
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("\(APIClient.getToekn())", forHTTPHeaderField: "X-AUTH")
    urlRequest.httpBody = try JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
        
    return urlRequest
  }
}
