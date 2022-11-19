//
//  SNSSignInViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

enum NicknameValidationResult {
  case ok(message: String)
  case short(message: String)
  case wrongForm(messge: String)
}

final class SNSSignInViewReactor: Reactor {
  
  enum Action {
    case nicknameInput(_ nickname: String)
  }
  
  enum Mutation {
    case validateNickname(String)
  }
  
  struct State {
    var validatedNickname = BehaviorRelay<NicknameValidationResult>(value: .short(message: ""))
  }
    
  var initialState: State = State()
  let provider: ServiceProviderType
  let uid: String

  init(provider: ServiceProviderType, uid: String) {
    self.provider = provider
    self.uid = uid
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    
    case let .nicknameInput(input):
      return Observable.just(Mutation.validateNickname(input))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
      
    case let .validateNickname(input):
      
      state.nickNameMessage = self.isValidNickname(input: input)
      return state
    }
  }
}

// MARK: - Method

/// email 입력값 확인해서 message 출력
private extension SNSSignInViewReactor {
  
  func isValidNickname(input: String) -> NSAttributedString {
    let nicknameRegEx = "[가-힣A-Za-z0-9]{2,8}"
    let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
    var message: NSAttributedString
    
    if input.count == 0 {
      message = NSAttributedString(string: "")
    } else if input.count == 1 {
      message = NSAttributedString(
        string: "2자 이상 올바른 형식으로 입력해주세요.",
        attributes: [.foregroundColor: UIColor.systemRed]
      )
    } else if nicknameTest.evaluate(with: input) == false {
      message = NSAttributedString(
        string: "특수 문자 없이 8자 이하로 입력해주세요.",
        attributes: [.foregroundColor: UIColor.systemRed]
      )
    } else {
      message = NSAttributedString(
        string: "사용가능한 별명 입니다.",
        attributes: [.foregroundColor: UIColor.systemGray]
      )
    }
    return message
  }
  
  func validateNickname(_ nickname: String) -> Observable<ValidationResult> {
    let nicknameRegEx = "[가-힣A-Za-z0-9]{2,8}"
    let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
    
    if nickname.count == 0 {
      
    }
  }
  
  
}
