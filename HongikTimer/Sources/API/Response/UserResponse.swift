//
//  UserResponse.swift
//  HongikTimer
//
//  Created by Jeff Jeong on 2022/11/18.
//

import Foundation

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

// MARK: - Welcome
struct TodosResponse: Codable {
  let data: [Todo]?
}

struct Todo: Codable {
  let taskID: Int?
  let contents, date: String?
  let isChecked: Bool?
  
  enum CodingKeys: String, CodingKey {
    case taskID = "taskId"
    case contents, date
    case isChecked
  }
}

// MARK: - Group

// getClubs
struct ClubsResponse: Codable {
  let data: [Club]?
}

struct Club: Codable {
  let id: Int?
  let leaderName, clubName, clubInfo: String?
  let leaderId: Int?
  let numOfMember, joinedMemberNum, totalStudyTime: Int?
  let createDate: String?
}

// getClub
struct GetClubResponse: Codable {
  let id: Int?
  let leaderId: Int?
  let leaderName, clubName, clubInfo: String?
  let numOfMember, joinedMemberNum, totalStudyTime: Int?
  let createDate: String?
  let members: Members?
}

struct Members: Codable {
  let data: [Member]?
}

struct Member: Codable {
  let memberID: Int?
  let username: String?
  let studyTime: Int?
  
  enum CodingKeys: String, CodingKey {
    case memberID = "memberId"
    case username, studyTime
  }
}

// create club
struct CreateClubResponse: Codable {
  let clubID: Int?
  let leaderName, clubName: String?
  let numOfMember: Int?
  let clubInfo, createDate: String?
  
  enum CodingKeys: String, CodingKey {
    case clubID = "clubId"
    case leaderName, clubName, numOfMember, clubInfo, createDate
  }
}
