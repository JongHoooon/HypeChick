//
//  GroupCellReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/22.
//

import ReactorKit
import RxCocoa
import RxSwift

final class GroupCellReactor: Reactor, BaseReactorType {
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    var member: Member
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(member: Member, provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(member: member)
  }
  
  //  func mutate(action: Action) -> Observable<Mutation> {
  //    <#code#>
  //  }
  //
  //  func reduce(state: State, mutation: Mutation) -> State {
  //    <#code#>
  //  }
}
