//
//  BoardViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/04.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

typealias BoardListSection = SectionModel<Void, BoardViewCellReactor>

final class BoardViewReactor: Reactor, BaseReactorType {
  
  enum Action {
    case refresh
  }
  
  enum Mutation {
    case setSetcions([BoardListSection])
  }
  
  struct State {
    var sections: [BoardListSection]
  }
  
  // MARK: - Property
  
  let provider: ServiceProviderType
  let user: User
  let initialState: State
  
  // MARK: - Initialize
  
  init(_ provider: ServiceProviderType, with user: User) {
    self.user = user
    self.provider = provider
    self.initialState = State(sections: [])
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    var newMutation: Observable<Mutation>
    switch action {
    case .refresh:
      newMutation = getRefreshMutation()
    }
    return newMutation
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setSetcions(sections):
      state.sections = sections
      
      return state
    }
  }
}

// MARK: - Method

extension BoardViewReactor {
  private func getRefreshMutation() -> Observable<Mutation> {
    
    let boardPosts = self.provider.boardService.fetchBoardPosts()
    
    return boardPosts.map { boardPosts in
      let sectionItems = boardPosts.map(BoardViewCellReactor.init)
      let section = BoardListSection(model: Void(), items: sectionItems)
      return .setSetcions([section])
    }
  }
  
  func reactorForWriteView() -> WriteViewReactor {
    return WriteViewReactor(self.provider, user: self.user)
  }
  
  func reactorForEnterView() -> EnterViewReactor {
    return EnterViewReactor(self.provider, user: self.user)
  }
}
