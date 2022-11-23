//
//  GroupEditViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/23.
//

import ReactorKit
import RxCocoa
import RxSwift

final class GroupEditViewReactor: Reactor {
  
  enum Action {
    case close
    case updateText(title: String, content: String)
    case submit
  }
  
  enum Mutation {
    case dismiss
    
    case validateCanSubmit
    case updateText(title: String, content: String)
  }
  
  struct State {
    var isDismissed: Bool = false
    var canSubmit: Bool = true
    
    var title: String? = ""
    var selectNumber: Int = 0
    var content: String?
    var clubResponse: GetClubResponse
  }
  
  let provider: ServiceProviderType
  var initialState: State
  
  init(_ provider: ServiceProviderType, clubResponse: GetClubResponse) {
    self.provider = provider
    self.initialState = State(clubResponse: clubResponse)
    initialState.selectNumber = clubResponse.numOfMember ?? 0
    initialState.title = clubResponse.clubName ?? ""
    initialState.content = clubResponse.clubInfo
    
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    var newMutation: Observable<Mutation>
    switch action {
    case .close:
      newMutation = .just(.dismiss)
          
    case let .updateText(title, content):
      newMutation = Observable.concat([
        Observable.just(.updateText(title: title, content: content)),
        Observable.just(.validateCanSubmit)
      ])
      
    case .submit:
      
      guard self.currentState.canSubmit else { return .empty() }
      
      #warning("User Info 흐름 처리 어떻게 하는게 좋을까???")
      guard let id = self.provider.userDefaultService.getUser()?.userInfo.id else { return .empty() }
      return self.provider.apiService.editClub(clubName: currentState.title ?? "",
                                        clubInfo: currentState.content ?? "",
                                        clubID: currentState.clubResponse.id ?? 0)
      .map { result in
        switch result {
        case .success:
          return .dismiss
        case .failure:
          return .dismiss
        }
      }
    }
    
    return newMutation
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .dismiss:
      state.isDismissed = true
      
    // TODO: contentTextView place holder랑 충돌
    case .validateCanSubmit:
      if state.title != nil && state.selectNumber != 0 && state.content != nil {
        state.canSubmit = true
      } else {
        state.canSubmit = false
      }
            
    case .updateText(title: let title, content: let content):
      state.title = title
      state.content = content
    }
    
    return state
  }
}
