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
  case register(_ request: RegisterRequest)
  
  /// 이메일 로그인
  case emailLogin(_ request: EmailLoginRequest)
  
  case snsLogin(_ request: SNSLoginRequest)
  
  // MARK: - End Point
  
  var path: String {
    switch self {
    case .snsLogin(let request):      return "v1/socialLogin/\(request.kind.rawValue)"
    case .emailLogin:                 return "v1/login"
    default:                          return "v1/members"
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
    let param = Parameters()
    
    switch self {
    case .emailLogin(let request):      return request.parameters
    case .register(let request):        return request.parameters
    case .snsLogin(let request):        return request.parameters
    }
  }
  
  // MARK: - URL Request
  func asURLRequest() throws -> URLRequest {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    
    urlRequest.method = self.method
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = try JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
    
    return urlRequest
  }
}
