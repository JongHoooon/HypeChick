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
  
  // MARK: - Cases
  
  /// 전체 그룹 조회 - 게시판에 표시
  case getClubs
  
  /// 특정 그룹 조회 - user가 가입한 group 표시할때 사용
  case getClub(_ request: ClubGetRequest)
  
  /// 그룹 생성 - 게시판 글쓰기
  case createClub(_ request: CreateClubRequest)
  
  /// 그룹 삭제
  case deleteClub(_ request: DeleteClubRequest)
  
  /// 그룹 수정 - 그룹 이름, 그룹 정보 수정
  case editClub(_ request: EditClubInfoRequest)
  
  /// 그룹 가입
  case signInClub(_ request: SignInClubRequest)
  
  // MARK: - End Point
  
  var path: String {
    switch self {
    case .getClubs:               return "clubs"
    case .getClub(let req):       return "clubs/\(req.clubID)"
    case .createClub:             return "clubs"
    case .deleteClub(let req):    return "clubs/\(req.clubID)"
    case .editClub(let req):      return "clubs/\(req.clubID)"
    case .signInClub(let req):    return "clubs/\(req.clubID)/\(req.memberID)"
    }
  }
  
  // MARK: - Method
  
  var method: HTTPMethod {
    switch self {
    case .getClubs:                return .get
    case .getClub:                 return .get
    case .createClub:              return .post
    case .deleteClub:              return .delete
    case .editClub:                return .put
    case .signInClub:              return .get
    }
  }
  
  // MARK: - Parameters
  
  var parameters: Parameters? {
    switch self {
    case .getClubs:                 return nil
    case .getClub:                  return nil
    case .createClub(let req):      return req.parameters
    case .deleteClub:               return nil
    case .editClub(let req):        return req.parameters
    case .signInClub:               return nil
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
