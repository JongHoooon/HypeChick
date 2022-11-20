//
//  RegisterRequest.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation

// MARK: - Auth

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

struct SNSRegisterRequest {
  let uid: String
  let username: String
  let kind: LoginKind
  
  var parameters: [String: Any] {
    return [
      "uid": uid,
      "username": username
    ]
  }
}

// MARK: - Todo

struct TodoPostRequest {
  let contents: String
  let date: String
  
  var parameters: [String: Any] {
    return [
      "contents": contents,
      "date": date
    ]
  }
}

struct TodoContentsEditRequest {
  let contents: String
  let taskId: String
  
  var parameters: [String: Any] {
    return [
      "contents": contents
    ]
  }
}

struct TodoDeleteRequest {
  let taskId: Int
}

struct TodoCheckRequest {
  let taskId: Int
}

// MARK: - Group

//struct
