//
//  ServiceProvider.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/31.
//

import Foundation
import NaverThirdPartyLogin

protocol ServiceProviderType: AnyObject {
  var authService: AuthService { get }
  var appleAuthService: AppleAuthService { get }
  var googleAuthService: GoogleAuthService { get }
  var kakaoAuthService: KakaoAuthService { get }
  //  var  naverAuthService: NaverThirdPartyLoginConnection { get }
  var authNotificationService: AuthNotificationManager { get }
  var  todoNotificationService: TodoNotificationService { get }
  var  userDefaultService: UserDefaultService { get }
  var boardService: BoardService { get }
  var alertService: AlertService { get }
  var todoService: TodoService { get }
  var apiService: APIService { get }
}

final class ServiceProvider: ServiceProviderType {
  
  let authService = AuthService()
  let appleAuthService = AppleAuthService()
  let googleAuthService = GoogleAuthService()
  let kakaoAuthService = KakaoAuthService()
  let naverAuthService = NaverThirdPartyLoginConnection.getSharedInstance()
  let authNotificationService = AuthNotificationManager()
  let todoNotificationService = TodoNotificationService()
  let userDefaultService = UserDefaultService()
  let boardService = BoardService()
  let alertService = AlertService()
  let todoService = TodoService()
  let apiService = APIService()
}
