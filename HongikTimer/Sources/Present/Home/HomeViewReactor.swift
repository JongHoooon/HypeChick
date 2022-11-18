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

  let user: User
  let provider: ServiceProviderType
  
  enum Action {
    case refresh
  }
  
  enum Mutation {
    
  }
  
  struct State {
//    var purposeLabel: String
    var chickImage: UIImage?
    var studyTime: String
  }
  
  let initialState: State
  = State(
//    purposeLabel: "탭하여 목표를 입력하세요!",
    chickImage: UIImage(named: "chick1"),
    studyTime: "00:00:00"
  )
  
  init(_ provider: ServiceProviderType, with user: User) {
    self.user = user
    self.provider = provider
    
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return .empty()
  }
}
