//
//  UserResponse.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let id: Int?
    let username, email: String?
}

struct MyUser: Codable {
    let id: Int
    let username, email: String
    init(data: UserResponse) {
        self.id = data.id ?? 0
        self.username = data.username ?? ""
        self.email = data.email ?? ""
    }
}

struct BaseResponse<T: Codable>: Codable {
    let data: T?
    let message: String?
    let code: String?
}


// MARK: - Timer

struct TimerResponse: Codable {
  let id: Int?
  let time: Int?
}
