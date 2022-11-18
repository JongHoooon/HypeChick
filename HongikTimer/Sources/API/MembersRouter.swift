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
      return URL(string: API.BASE_URL)!
  }
  
  // MARK: - Cases
  
  /// 회원등록
  case register(_ request: RegisterRequest)
  
  /// 이메일 로그인
  case emailLogin(_ request: EmailLoginRequest)
  
  // MARK: - End Point
  
  var endPoint: String {
    switch self {
    case .emailLogin:   return "v1/login"
    default:            return "v1/members"
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
      case let .emailLogin(request):
          return request.parameters
      case let .register(request):
          return request.parameters
      }
  }
  
  // MARK: - Headers
  
  var headers: HTTPHeaders {
    switch self {
    default:
      return [
        "Accept": "application/json"
      ]
    }
  }
  
  // MARK: - URL Request
  func asURLRequest() throws -> URLRequest {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(endPoint))
    
    urlRequest.method = self.method
    
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    urlRequest.httpBody = try JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
    
    print("DEBUG parameterss!!!!!!!!!!")
    print("DEBUG \(parameters!)")
    print("DEBUG request !!!!!! \(urlRequest.httpBody?.description)")
    
    return urlRequest
  }
}
