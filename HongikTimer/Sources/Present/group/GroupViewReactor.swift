//
//  GroupViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/22.
//

import ReactorKit
import RxCocoa
import RxSwift

final class GroupViewReactor: Reactor, BaseReactorType {
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  let provider: ServiceProviderType
  let initialState = State()
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
  
  //  func mutate(action: Action) -> Observable<Mutation> {
  //    <#code#>
  //  }
  //
  //  func reduce(state: State, mutation: Mutation) -> State {
  //    <#code#>
  //  }
}
