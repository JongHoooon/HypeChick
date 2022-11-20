//
//  SetPurposeViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/21.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class SetPurposeViewReactor: Reactor {
  
  enum Action {
    case countText(text: String)
  }
  
  enum Mutation {
    case countText(count: Int)
  }
  
  struct State {
    
  }
  
  let initialState = State()
  
  init() {
    
  }
  
  //  func mutate(action: Action) -> Observable<Mutation> {
  //    <#code#>
  //  }
  //
  //  func reduce(state: State, mutation: Mutation) -> State {
  //    <#code#>
  //  }
}
