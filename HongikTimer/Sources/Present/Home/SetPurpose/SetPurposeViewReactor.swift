//
//  SetPurposeViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/21.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class SetPurposeViewReactor: Reactor, BaseReactorType {
 
  enum Action {
    case countText(text: String)
  }
  
  enum Mutation {
    case countText(count: Int)
  }
  
  struct State {
    var count: Int = 0
  }
  
  let initialState = State()
  
  var userInfo: UserInfo
  var provider: ServiceProviderType
  
  init(provider: ServiceProviderType, userInfo: UserInfo) {
    self.provider = provider
    self.userInfo = userInfo
  }
  
    func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .countText(let text):
        let count = text.count
        return .just(.countText(count: count))
      }
    }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case .countText(let count):
      state.count = count
    }
    return state
  }
}
