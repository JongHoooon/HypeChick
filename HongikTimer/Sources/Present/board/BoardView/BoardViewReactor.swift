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
  let userInfo: UserInfo
  let initialState: State
  
  // MARK: - Initialize
  
  init(_ provider: ServiceProviderType, with userInfo: UserInfo) {
    self.userInfo = userInfo
    self.provider = provider
    self.initialState = State(sections: [])
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      print("refresh")
      
      return self.provider.apiService.getClubs()
        .map { result in
          switch result {
          case .success(let clubs):
            let sectionItems = clubs.map { BoardViewCellReactor.init(club: $0, provider: self.provider) }
            let section = BoardListSection(model: Void(), items: sectionItems)
            return .setSetcions([section])
            
          case .failure:
            print("실패")
            return .setSetcions([])
          }
        }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setSetcions(sections):
      
      print("set section")
      state.sections = sections
      
      print(state.sections)
      
      return state
    }
  }
}

// MARK: - Method

extension BoardViewReactor {
  
  //  private func getRefreshMutation() -> Observable<Mutation> {
  //
  //    return self.provider.apiService.getClubs()
  //      .map { result in
  //
  //        switch result {
  //        case .success(let clubs):
  //          let sectionItems = clubs.map {
  //
  //            print($0)
  //
  //            return BoardViewCellReactor.init(club: $0, provider: self.provider) }
  //
  //          let section = BoardListSection(model: Void(), items: sectionItems)
  //          return .setSetcions([section])
  //        case .failure:
  //          return .setSetcions([])
  //        }
  //      }
  //  }
  
  func reactorForWriteView() -> WriteViewReactor {
    return WriteViewReactor(self.provider, userInfo: self.userInfo)
  }
  
  func reactorForEnterView() -> EnterViewReactor {
    return EnterViewReactor(self.provider, userInfo: self.userInfo)
  }
}

