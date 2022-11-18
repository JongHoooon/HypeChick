//
//  APIService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation
import Alamofire

class APIService {

  // MARK: - Todo
  
  func createTask(contents: String, date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_kr")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    AF.request(APIRouter.postTask(
      contents: contents,
      date: dateFormatter.string(from: date))
    ).responseData { dataResponse in
      switch dataResponse.result {
      case .success:
        print("DEBUG TODO POST 성공")
        
//        dataResponse.value.
      case .failure:
        print("DEBUG TODO POST 실패")
      }
    }
  }
  
//  func getTasks -> Observable<[Task]> {
//    AF.request(APIRouter.getTasks).responseData { dataResponse in
//
//      switch dataResponse.result {
//
//      case .success
//        guard let value = dataResponse.value else { return }
//        value["data"]
//      }
//    }
//  }
  
  // MARK: - Timer
  
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
        guard let result = response.value as? [String: Int] else {
          print("DEBUG 시간 불러오기 실패!!!!!!!!!")
          return }
        guard let time = result["time"] else { return }
        print("DEBUG \(time) 만큼 출력")
        
        completion(time)
      }
  }
}
