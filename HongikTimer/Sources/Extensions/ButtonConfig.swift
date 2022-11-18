//
//  ButtonConfig.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/14.
//

import UIKit
import Then

enum Config {
  case white
  case label
  case snsLogin
  
  var config: UIButton.Configuration {
    var filledConfig = UIButton.Configuration.filled()
    
    switch self {
      
    case .white:
      filledConfig.cornerStyle = .capsule
      filledConfig.baseBackgroundColor = .white
      return filledConfig
    case .label:
      filledConfig.cornerStyle = .capsule
      filledConfig.baseBackgroundColor = .label
      return filledConfig
    case .snsLogin:
      filledConfig.cornerStyle = .capsule
      filledConfig.baseBackgroundColor = .label
      filledConfig.imagePadding = 16.0
      return filledConfig
      
    }
  }
}

struct ButtonConfig {
  private let buttonConfig: Config
  
  init(buttonConfig: Config) {
    self.buttonConfig = buttonConfig
  }
  
  func getConfig() -> UIButton.Configuration {
    return buttonConfig.config
  }
}

let labelConfig = ButtonConfig(buttonConfig: .label).getConfig()
let snsLoginConfig = ButtonConfig(buttonConfig: .snsLogin).getConfig()
