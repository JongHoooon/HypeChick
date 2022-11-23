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

// MARK: - Todo & Home

struct SaveGoalRequest {
  let goal: String
  
  var parametrs: [String: Any] {
    return [
      "goal": goal
    ]
  }
}

struct TodoPostRequest {
  let contents: String
  let date: String
  
  var parameters: [String: Any] {
    return [
      "contents": contents,
      "date": date
    ]
  }
  
  init(contents: String, date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_kr")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    self.contents = contents
    self.date = dateFormatter.string(from: date)
  }
}

struct TodoContentsEditRequest {
  let contents: String
  let taskId: Int
  
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

struct ClubGetRequest {
  let clubID: Int
}

struct CreateClubRequest {
  let memberID: Int
  let clubName: String
  let numOfMember: Int
  let clubInfo: String
  
  var parameters: [String: Any] {
    return [
      "memberId": memberID,
      "clubName": clubName,
      "numOfMember": numOfMember,
      "clubInfo": clubInfo
    ]
  }
}

struct DeleteClubRequest {
  let clubID: Int
}

struct EditClubInfoRequest {
  let clubName: String
  let clubInfo: String
  let clubID: Int
  
  var parameters: [String: Any] {
    return [
      "clubName": clubName,
      "clubInfo": clubInfo
    ]
  }
}

struct SignInClubRequest {
  let clubID: Int
  let memberID: Int
}

struct LeaveClubRequest {
  let clubID: Int
  let memberID: Int
}
