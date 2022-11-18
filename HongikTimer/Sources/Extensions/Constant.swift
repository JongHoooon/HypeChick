//
//  Constant.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/15.
//

import Firebase
import Foundation

let textFieldHeight: CGFloat = 16.0
let snsButtonHeight: CGFloat = 44.0
let authDefaultInset: CGFloat = 24.0

// MARK: - Firebase REF

let dbREF = Database.database().reference()
let refUSERS = dbREF.child("users")

// MARK: - URL

enum URLs {
  case login
  case signin
  
  var url: String {
    switch self {
      // TODO: 회원가입 url 수정해야햠
    case .signin:
      return "http://localhost:8080/api/members"
    case .login:
      return "http://localhost:8080/api/login"
    }
  }
}
