//
//  NaverAuthService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/18.
//

import Alamofire
import NaverThirdPartyLogin
import UIKit

final class NaverAuthService: NSObject {
  
  var shared = NaverThirdPartyLoginConnection.getSharedInstance()
  
  init(delegate: NaverThirdPartyLoginConnectionDelegate) {
    self.shared?.delegate = delegate
  }
}
