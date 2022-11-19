//
//  AuthCredentials.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/15.
//

import Foundation

struct AuthCredentials {
    let email: String
    let username: String
    let password: String
  
  
  func getRegisterRequest() -> RegisterRequest {
      return RegisterRequest(email: email, username: username, password: password)
  }
}
