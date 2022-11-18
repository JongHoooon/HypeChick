//
//  AuthResponse.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/12.
//

import Foundation

struct AuthResponse: Codable {
    var result: String
    var expiresIn: Int
    var token: String
    var message: String
    var userInfo: User
    
    enum CodingKeys: String, CodingKey {
        case result
        case expiresIn = "expires_in"
        case token
        case message
        case userInfo = "user_info"
    }
}
