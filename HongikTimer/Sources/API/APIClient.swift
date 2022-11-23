//
//  APIClient.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/19.
//

import Alamofire
import Foundation

class APIClient {
  
//  static var userId: Int? = {
//    print("user id 호출")
//    return UserDefaultService.shared.getUser()?.userInfo.id }()
//  static var token: String? = { UserDefaultService.shared.getUser()?.token }()
  
  static func getid() -> Int {
    guard let id = UserDefaultService.shared.getUser()?.userInfo.id else { return 0 }
    return id
  }
  
  static func getToekn() -> String {
    guard let token = UserDefaultService.shared.getUser()?.token else { return "" }
    return token
  }
  
//  static let BASE_URL: String = "http://localhost:8080/api"
  static let BASE_URL: String = "http://ec2-15-164-9-1.ap-northeast-2.compute.amazonaws.com:8080/api"
  
  static func request<T: Decodable, U: URLRequestConvertible>(
    _ object: T.Type,
    router: U,
    completion: @escaping (Result<T, ApiError>) -> Void
  ) {
    AF.request(router)
      .validate(statusCode: 200...299)
      .responseDecodable(of: object) { dataResponse in
        switch dataResponse.result {
        case .success:
          guard let decodedData = dataResponse.value else { return }
          completion(.success(decodedData))
          
        case .failure(let err):
          completion(.failure(ApiError.unknown(err)))
        }
      }
  }
  
  /// 에러 처리
  /// - Parameter err: APIError
  static func handleError(_ err: ApiError) {
    
    print("error: \(err.info)")
    
    switch err {
    case ApiError.notAccept:
      print("not Accep error: ")
    case ApiError.unknown(let err):
      print("unknoew error: \(String(describing: err))")
    case .badStatus(let code):
      print("bad status error code: \(code)")
    }
  }
}
