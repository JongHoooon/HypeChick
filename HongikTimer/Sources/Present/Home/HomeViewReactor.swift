//
//  HomeViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/01.
//

import ReactorKit
import RxCocoa
import RxSwift

final class HomeViewReactor: Reactor, BaseReactorType {
  
  enum Action {
//    case refresh
    case viewDidLoad
  }
  
  enum Mutation {
    case viewDidLoad(purpose: String)
  }
  
  struct State {
    var purposeText: String?
    var chickImage: UIImage?
    var studyTime: String
  }
  
  let initialState: State
  = State(
    purposeText: "",
    chickImage: UIImage(named: "chick1"),
    studyTime: "00:00:00"
  )
  
  let userInfo: UserInfo
  let provider: ServiceProviderType
  
  init(_ provider: ServiceProviderType, with userInfo: UserInfo) {
    self.userInfo = userInfo
    self.provider = provider
    
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      
      print("view did load did load vdid loaddid loaddid loaddid loaddid load")
      
      return .just(.viewDidLoad(purpose: provider.userDefaultService.getUser()?.userInfo.goal ?? ""))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case.viewDidLoad(let purpose):
      state.purposeText = purpose
      print(state.purposeText)
    }
    
    return state
  }
}
