//
//  APIService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation
import Alamofire

class APIService {
  
  // timer
  
  func saveTime(second: Int) {
    
    AF.request(APIRouter.postTime(second: second)).responseJSON { response in
      
      guard let result = response.value as? [String: Int] else {
        print("DEBUG timer 저장 실패")
        return }
      guard let time = result["time"] else { return }
      
      print("DEBUG \(time)초 만큼 저장")
    }
  }
  
  func getTodayTime(completion: @escaping (Int) -> Void) {
    
    AF.request(APIRouter.getTodayTime)
      .responseJSON { response in
        guard let result = response.value as? [String: Int] else { return }
        guard let time = result["time"] else { return }
        
        completion(time)
      }
  }
}
