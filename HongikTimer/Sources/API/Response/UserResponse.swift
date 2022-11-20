//
//  UserResponse.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
  let data: T?
  let message: String?
  let code: String?
}

// MARK: - UserResponse
//struct UserResponse: Codable {
//  let id: Int?
//  let username, email: String?
//}
//
//struct MyUser: Codable {
//  let id: Int
//  let username, email: String
//  init(data: UserResponse) {
//    self.id = data.id ?? 0
//    self.username = data.username ?? ""
//    self.email = data.email ?? ""
//  }
//}

// MARK: - Timer

struct TimerResponse: Codable {
  let id: Int?
  let time: Int?
}

// MARK: - Welcome
struct TodosResponse: Codable {
  let data: [Todo]?
}

struct Todo: Codable {
  let taskID: Int?
  let contents, date: String?
  let isChecked: Bool?
  
  enum CodingKeys: String, CodingKey {
    case taskID = "taskId"
    case contents, date
    case isChecked
  }
  
  /// 더미 생성용
  init() {
    self.taskID = 999
    self.contents = "더미"
    self.date = "2022-11-20"
    self.isChecked = false
  }
}
