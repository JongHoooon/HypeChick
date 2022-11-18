//
//  User.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/11.
//

import Foundation

struct User: Codable {
    let id: Int
    var username: String
    let email: String
    
    init() {
        self.id = 1
        self.username = "김홍익"
        self.email = "user1@gmail.com"
    }
}
