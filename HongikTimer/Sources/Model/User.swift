//
//  User.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation

struct User: Codable {
    let result: String
    let expiresIn: Int
    let token, message: String
    var userInfo: UserInfo

    enum CodingKeys: String, CodingKey {
        case result
        case expiresIn = "expires_in"
        case token, message
        case userInfo = "user_info"
    }
}
