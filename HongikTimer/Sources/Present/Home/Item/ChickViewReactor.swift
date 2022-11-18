//
//  ChickViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import ReactorKit

final class ChickViewReactor: Reactor, BaseReactorType {
  
  var user: User
  var provider: ServiceProviderType
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  let initialState: State = State()
  
  init(_ provider: ServiceProviderType, with user: User) {
    self.user = user
    self.provider = provider
  }
}
