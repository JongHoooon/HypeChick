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

// MARK: - URL

enum API {
    #if DEBUG // 개발
    static let VERSION = "/v1"
    static let BASE_URL : String = "http://localhost:8080/api"
    #else // 배포
    static let BASE_URL : String = "http://www.naver.com"
    #endif
}
