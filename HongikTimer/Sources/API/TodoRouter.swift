//
//  TodoRouter.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/20.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
  
  // MARK: - Property
  var baseURL: URL {
    return URL(string: APIClient.BASE_URL)!
  }
  
  var userId: Int {
    guard let userId = APIClient.userId else { return 0 }
    return userId
  }
  
  // MARK: - Cases
  
  /// 사용자가 쓴 투두 전체 조회
  case getTasks
  
  /// 투두 등록
  case postTask(_ request: TodoPostRequest)
  
  /// 투두 수정 (내용)
  case updateTodo(_ request: TodoContentsEditRequest)
  
  /// 투두 삭제
  case deleteTodo(_ request: TodoDeleteRequest)
  
  /// 투두 체크
  case checkTodo(_ request: TodoCheckRequest)
  
  // MARK: - End Point
  
  var path: String {
    switch self {
    case .getTasks, .postTask:        return "tasks/\(userId)"
    case .updateTodo(let request):    return "tasks/\(userId)/\(request.taskId)"
    case .deleteTodo(let request):    return "tasks/\(userId)/\(request.taskId)"
    case .checkTodo(let request):     return "tasks/check/\(request.taskId)"
    }
  }
  
  // MARK: - Method
  
  var method: HTTPMethod {
    switch self {
    case .getTasks:                   return .get
    case .postTask:                   return .post
    case .updateTodo:                 return .put
    case .deleteTodo:                 return .delete
    case .checkTodo:                  return .get
    }
  }
  
  // MARK: - Parameters
  
  var parameters: Parameters? {
    switch self {
    case .getTasks:                   return nil
    case .postTask(let request):      return request.parameters
    case .updateTodo(let request):    return request.parameters
    case .deleteTodo:                 return nil
    case .checkTodo:                  return nil
    }
  }
  
  // MARK: - URL Request
  func asURLRequest() throws -> URLRequest {
    
    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
    
    urlRequest.method = self.method
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("\(APIClient.token ?? "")", forHTTPHeaderField: "X-AUTH")
    urlRequest.httpBody = try JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
    
    return urlRequest
  }
}
