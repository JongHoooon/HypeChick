//
//  User.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/11.
//

import Foundation

struct UserInfo: Codable {
  let id: Int?
  var username: String?
  let email: String?
  let socialType: String?
  var totalStudyTime: Int?
  var todayStudyTime: Int?
  var level: String?
  var clubID: Int?
  var goal: String?
  
  enum CodingKeys: String, CodingKey {
    case id, username, email, socialType, totalStudyTime, todayStudyTime, level
    case clubID = "clubId"
    case goal
  }
}
