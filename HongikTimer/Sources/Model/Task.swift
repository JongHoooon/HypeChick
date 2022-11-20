//
//  Task.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/28.
//

import Foundation

struct Task: Codable, Identifiable {
  
  var id = UUID().uuidString
  var taskID: Int?
  var contents: String?
  var isChecked: Bool?
  let date: String
  
  /// todo로 response 받은거 task로 변형
  init(todo: Todo) {
    self.contents = todo.contents
    self.date = todo.date ?? ""
    self.taskID = todo.taskID
    self.isChecked = todo.isChecked
  }
  
  /// 더미 생성용
  init(default: Bool) {
    self.contents = "스위프트 문법 공부"
    self.isChecked = false
    self.date = "2022-11-11"
  }
  
  /// 더미 생성용
  init(
    contents: String
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_kr")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    self.contents = contents
    self.isChecked = false
    self.date = dateFormatter.string(from: Date())
  }
  
  init(contents: String, day: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_kr")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    self.contents = contents
    self.isChecked = false
    self.date = dateFormatter.string(from: day)
  }
}
