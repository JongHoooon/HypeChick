//
//  EmailLoginViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/20.
//

import ReactorKit
import RxCocoa
import RxSwift

final class EamilLoginViewReactor: Reactor {
  
  enum Action {
    case emailInput(_ email: String)
    case passwordInput(_ password: String)
  }
  
  enum Mutation {
    case emailInput(_ email: String)
    case passwordInput(_ password: String)
  }
  
  struct State {
    var email: String = ""
    var password: String = ""
  }
  
  let provider: ServiceProviderType
  let initialState = State()
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
  
    func mutate(action: Action) -> Observable<Mutation> {
      switch action {
      case .emailInput(let email):
        return .just(.emailInput(email))
        
      case .passwordInput(let password):
        return .just(.passwordInput(password))
      }
    }
  
    func reduce(state: State, mutation: Mutation) -> State {
      var state = state
      
      switch mutation {
      case .emailInput(let email):
        state.email = email
      case .passwordInput(let password):
        state.password = password
      }
      return state
    }
}
