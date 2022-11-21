//
//  APIRouter.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/17.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
  
 // MARK: - Property
  
  static let user = UserDefaultService.shared.getUser()
  
  var baseURL: URL {
//    return URL(string: "http://localhost:8080/api")!
    return URL(string: "http://ec2-15-164-9-1.ap-northeast-2.compute.amazonaws.com:8080/api")!
  }
  
  // MARK: - Cases
  
  // auth
  case emailSignIn(email: String, username: String, password: String)
  case emailLogin(email: String, password: String)
  
  // todo

  
  // timer
  
  
  // board, group

  
  
  // MARK: - End Point
  
  var endPoint: String {
    guard let userId = APIRouter.user?.userInfo.id else { return ""}
    switch self {
    // auth
    case .emailSignIn:
      return "v1/members"
    case .emailLogin:
      return "v1/login"
    
    // todo

    
    // timer
   
     
    // board, group

    
    }
  }
  
  // MARK: - Method
  
  var method: HTTPMethod {
    switch self {
    // auth
    case .emailSignIn:
      return .post
    case .emailLogin:
      return .post

      
    // todo

    
    // timer
   
    
    // board, group

    }
  }
  
  // MARK: - Parameters
  
  var parameters: Parameters? {
    var params = Parameters()
    
    switch self {
      
    // auth
    case let .emailSignIn(email, username, password):
      params["email"] = email
      params["username"] = username
      params["password"] = password
      
    case let .emailLogin(email, password):
      params["email"] = email
      params["password"] = password
      
    // todo

      
    // timer
   
      
    // board, group

      

    }
    return params
  }
  
  // MARK: - URL Request
  
  func asURLRequest() throws -> URLRequest {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(endPoint))

    urlRequest.method = self.method

    switch self.method {
      
    case .get:
      return urlRequest
      
    case .post:
      if let parameters = parameters {
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
      }
      
    case .put:
      urlRequest.httpBody = try JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
      
    default:
      return urlRequest
    }

    return urlRequest
  }
}
