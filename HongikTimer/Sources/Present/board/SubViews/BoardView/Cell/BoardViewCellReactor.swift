//
//  BoardViewCellReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/06.
//

import ReactorKit
import RxCocoa
import RxSwift

final class BoardViewCellReactor: Reactor, BaseReactorType {
  
  
  typealias Action = NoAction
  
  struct State {
    let club: Club
  }
  
  lazy var userInfo: UserInfo? = {
    let userInfo = self.provider.userDefaultService.getUser()?.userInfo
    return userInfo
  }()
  
  var provider: ServiceProviderType
  var initialState: State
  
  init(club: Club, provider: ServiceProviderType) {
    self.initialState = State(club: club)
    self.provider = provider
  }
}
