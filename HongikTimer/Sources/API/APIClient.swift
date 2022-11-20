//
//  APIClient.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/19.
//

import Alamofire
import Foundation

class APIClient {
  
  static let userId = UserDefaultService.shared.getUser()?.userInfo.id!
  static let token = UserDefaultService.shared.getUser()?.token
  
  static let BASE_URL: String = "http://localhost:8080/api"
  
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
