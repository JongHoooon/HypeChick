//
//  EnterViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/11.
//

import ReactorKit
import RxCocoa
import RxSwift

final class EnterViewReactor: Reactor {
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    var boardPost: BoardPost? = nil
  }
  
  let provider: ServiceProviderType
  var userInfo: UserInfo
  var initialState: State
  
  init(
    _ provider: ServiceProviderType,
    userInfo: UserInfo
  ) {
    self.provider = provider
    self.userInfo = userInfo
    self.initialState = State()
  }
  
//  func mutate(action: Action) -> Observable<Mutation> {
//    <#code#>
//  }
//
//  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//    <#code#>
//  }
}
