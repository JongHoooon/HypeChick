//
//  User.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/11.
//

import Foundation

struct UserInfo: Codable {
    var id: Int
    var username: String
    var email: String
    
    init() {
        self.id = 1
        self.username = "김홍익"
        self.email = "user1@gmail.com"
    }
}
