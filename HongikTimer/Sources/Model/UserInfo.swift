//
//  User.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/11.
//

import Foundation

struct UserInfo: Codable {
  let id: Int?
  let username: String?
  let email: String?
  let socialType: String?
  let totalStudyTime: Int?
  let todayStudyTime: Int?
  let level: String?
  let clubID: Int?
  let goal: String?
  
  enum CodingKeys: String, CodingKey {
    case id, username, email, socialType, totalStudyTime, todayStudyTime, level
    case clubID = "clubId"
    case goal
  }
}
