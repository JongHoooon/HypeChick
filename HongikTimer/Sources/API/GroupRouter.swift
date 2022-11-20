//
//  GroupRouter.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/20.
//

import Foundation
import Alamofire

enum GroupRouter: URLRequestConvertible {
  
  // MARK: - Property
  var baseURL: URL {
    return URL(string: APIClient.BASE_URL)!
  }
  
  var userId: Int {
    guard let userId = APIClient.userId else { return 0 }
    return userId
  }
  
  // MARK: - Cases
  
  case getClubs
  case createClub(memberID: Int, clubName: String, numberOfMember: Int, clubInfo: String)
  case singInClub(clubId: Int)
  
  // MARK: - End Point
  
  var path: String {
    switch self {
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
    switch self {
    default: return nil
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

