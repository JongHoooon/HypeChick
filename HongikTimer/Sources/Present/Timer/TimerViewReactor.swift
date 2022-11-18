//
//  TimerViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/01.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

final class TimerViewReactor: Reactor {
  
  var user: User
  var provider: ServiceProviderType
  
  enum Action {
    case selectTime(TimeInterval)
  }
  
  enum Mutation {
    case selectTime(TimeInterval)
  }
  
  struct State {
    var timeLableText: String
  }
  
  let initialState = State(timeLableText: "00:00")
  
  init(_ provider: ServiceProviderType, with user: User) {
    self.user = user
    self.provider = provider
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .selectTime(selectTime):
      return Observable.just(Mutation.selectTime(selectTime))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = currentState
    switch mutation {
    case let .selectTime(selectTime):
      state.timeLableText = timeToString(time: selectTime)
      return state
    }
  }
}

private extension TimerViewReactor {
  func timeToString(time: TimeInterval) -> String {
    let time = Int(time)
    
    let hour = time / 3600
    let miniute = (time % 3600) / 60
    let second = (time % 3600) % 60
    
    let timeText = String(
      format: "%02d:%02d:%02d",
      hour,
      miniute,
      second
    )
    
    return timeText
  }
}
