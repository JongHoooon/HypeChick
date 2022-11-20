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
    return URL(string: "http://localhost:8080/api")!
  }
  
  // MARK: - Cases
  
  // auth
  case emailSignIn(email: String, username: String, password: String)
  case emailLogin(email: String, password: String)
  
  // todo
  case getTasks
  case postTask(contents: String, date: String)
  case updateTodo(contents: String, taskId: Int)
  case deleteTodo(taskId: Int)
  case checkTodo(taskId: Int)
  
  // timer
  
  
  // board, group
  case getClubs
  case createClub(memberID: Int, clubName: String, numberOfMember: Int, clubInfo: String)
  case singInClub(clubId: Int)
  
  
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
    case .getTasks, .postTask:
      return "tasks/\(userId)"
    case let .updateTodo(_, taskId), let .deleteTodo(taskId):
      return "tasks/\(userId)/\(taskId)"
    case let .checkTodo(taskId):
      return "tasks/check/\(taskId)"
    
    // timer
   
     
    // board, group
    case .getClubs:
      return "clubs"
    case .createClub:
      return "clubs"
    case let .singInClub(clubId):
      return "clubs/\(clubId)/\(userId)"
    
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
    case .deleteTodo:
      return .delete
    case .checkTodo:
      return .get
      
    // todo
    case .getTasks:
      return .get
    case .postTask:
      return .post
    case .updateTodo:
      return .put
    
    // timer
   
    
    // board, group
    case .getClubs:
      return .get
    case .createClub:
      return .post
    case .singInClub:
      return .get
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
    case .getTasks:
      return nil
      
    case let .postTask(contents, date):
      params["contents"] = contents
      params["date"] = date
    case let .updateTodo(contents, _):
      params["contents"] = contents
    case .deleteTodo:
      return nil
    case .checkTodo:
      return nil
      
    // timer
   
      
    // board, group
    case .getClubs:
      return nil
      
    case let .createClub(memberID, clubName, numberOfMember, clubInfo):
      params["memberID"] = memberID
      params["clubName"] = clubName
      params["numberOfMember"] = numberOfMember
      params["clubInfo"] = clubInfo
    case .singInClub:
      return nil
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
