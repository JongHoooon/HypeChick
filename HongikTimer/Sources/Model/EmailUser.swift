//
//  EmailUser.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation

struct EmailUser: Codable {
    let result: String
    let expiresIn: Int
    let token, message: String
    let userInfo: User

    enum CodingKeys: String, CodingKey {
        case result
        case expiresIn = "expires_in"
        case token, message
        case userInfo = "user_info"
    }
  
  /// 더미 init
  init() {
    self.result = "실패!!!!!"
    self.expiresIn = 0
    self.token = "토큰입니다"
    self.message = "실패"
    self.userInfo = User()
  }
}
