//
//  BoardPost.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/04.
//

import Foundation

struct BoardPost: Codable, Identifiable, Equatable {
  var id = UUID().uuidString
  var title: String
  var memberCount: Int = 1
  var maxMemberCount: Int
  var chief: String
  var startDay: String
  var totalTime: Int = 0
  var content: String
  
  init() {
    self.title = "파이썬 코테 스터디"
    self.maxMemberCount = 4
    self.memberCount = 1
    self.chief = "영미"
    self.startDay = "22. 4. 11"
    self.totalTime = 9799
    self.content = "파이썬 코딩테스트 모집합니다~~파이썬 코딩테스트 모집합니다~~파이썬 코딩테스트 모집합니다~~파이썬 코딩테스트 모집합니다~~"
  }
  
  init(
    title: String, memberCount: Int = 1, maxMemberCount: Int,
    chief: String, startDay: Date,
    content: String
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yy. MM. dd"
    dateFormatter.locale = Locale(identifier: "ko_kr")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    self.title = title
    self.maxMemberCount = maxMemberCount
    self.chief = chief
    self.startDay = dateFormatter.string(from: startDay)
    self.content = content
  }
}
