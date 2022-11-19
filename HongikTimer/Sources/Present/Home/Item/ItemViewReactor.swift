//
//  ItemViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ItemViewReactor: Reactor, BaseReactorType {
  
  var userInfo: UserInfo
  var provider: ServiceProviderType
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  let initialState: State = State()
  
  init(_ provider: ServiceProviderType, with userInfo: UserInfo) {
      self.userInfo = userInfo
      self.provider = provider
      
    }

}
