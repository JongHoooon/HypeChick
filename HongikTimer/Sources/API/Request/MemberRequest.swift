//
//  RegisterRequest.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation

struct EmailLoginRequest {
    let email: String
    let password: String
    
    var parameters: [String: Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}

struct RegisterRequest {
    let email: String
    let username: String
    let password: String
    
    var parameters: [String: Any] {
        return [
            "email": email,
            "username": username,
            "password": password
        ]
    }
}

struct SNSLoginRequest {
  let uid: String
  let kind: LoginKind
  
  var parameters: [String: Any] {
    return [
      "uid": uid
    ]
  }
}
