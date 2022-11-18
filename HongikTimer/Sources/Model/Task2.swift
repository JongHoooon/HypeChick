//
//  Task2.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation

struct TaskData: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let taskID: Int
    let contents, date: String

    enum CodingKeys: String, CodingKey {
        case taskID = "taskId"
        case contents, date
    }
}
