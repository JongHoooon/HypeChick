//
//  RegisterViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/31.
//

import UIKit
import ReactorKit

final class RegisterViewReactor: Reactor {
  
  var provider: ServiceProviderType

  enum Action {
    
  }
 
  struct State {
    
  }
  
  var initialState: State = State()

  init(_ provider: ServiceProviderType) {
    self.provider = provider
  }
  
}
