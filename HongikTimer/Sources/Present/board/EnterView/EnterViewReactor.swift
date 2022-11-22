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
    case tapEnterButton
  }
  
  enum Mutation {
    case tapEnterButton(sucess: Bool)
  }
  
  struct State {
    var club: Club?
    @Pulse var isCompleted: Bool?
  }
  
  let provider: ServiceProviderType
  lazy var userInfo: UserInfo? = {
    return self.provider.userDefaultService.getUser()?.userInfo
  }()
  var initialState: State
  
  init(
    _ provider: ServiceProviderType,
    userInfo: UserInfo
  ) {
    self.provider = provider
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapEnterButton:
      guard let clubID = currentState.club?.id else { return .empty() }
      guard var user = provider.userDefaultService.getUser() else { return .empty() }
      
      #warning("weak self??????????")
      return self.provider.apiService.signInClub(clubID: clubID, memberID: user.userInfo.id ?? 0)
        .map { result in
        
          switch result {
          case let .success(clubID):
            user.userInfo.clubID = clubID
            self.provider.userDefaultService.setUser(user)
            return .tapEnterButton(sucess: true)
            
          case .failure:
            return .tapEnterButton(sucess: false)
          }
        }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .tapEnterButton(sucess):
      state.isCompleted = sucess
    }
    
    return state
  }
}
