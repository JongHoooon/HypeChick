//
//  BoardViewCellReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/06.
//

import ReactorKit
import RxCocoa
import RxSwift

final class BoardViewCellReactor: Reactor {
  typealias Action = NoAction
  
  var initialState: BoardPost
  
  init(boardPost: BoardPost) {
    self.initialState = boardPost
  }
}
