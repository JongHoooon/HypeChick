//
//  TaskHeaderCellReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/12.
//

import ReactorKit
import RxCocoa
import RxSwift

final class TaskHeaderCellReactor: Reactor, BaseReactorType {
  
  enum Action {
    case plusTask
  }
  
  enum Mutation {
    case empty
  }
  
  struct State {
    
  }
  
  // MARK: - Property
  
  let provider: ServiceProviderType
  let userInfo: UserInfo
  let initialState = State()
  
  // MARK: - Init
  
  init(_ provider: ServiceProviderType, userInfo: UserInfo) {
    self.provider = provider
    self.userInfo = userInfo
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    
    switch action {
    case .plusTask:
      return self.provider.todoService.tapCreateButton()
        .map { .empty }
    }
  }
}
