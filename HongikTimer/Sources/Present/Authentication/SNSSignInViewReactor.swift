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

final class SNSSignInViewReactor: Reactor {
  
  
  enum Action {
    case emailInput(_ email: String)
    case nicknameInput(_ nickname: String)
    case passwordInput(String)
    case passwordCheckInput(String)
  }
  
  enum Mutation {
    case validateEmail(String)
    case validateNickname(String)
    case validatePassword(String)
    case validatePasswordCheck(String)
  }
  
  struct State {
    var emailMessage: NSAttributedString?
    var nickNameMessage: NSAttributedString?
    var passwordMessage: NSAttributedString?
    var passwordCheckMessage: NSAttributedString?
    var password: String?
    var passwordcheck: String?
  }
    
  var initialState: State = State()
  let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .emailInput(input):
      return Observable.just(Mutation.validateEmail(input))
    case let .nicknameInput(input):
      return Observable.just(Mutation.validateNickname(input))
    case let .passwordInput(input):
      return Observable.concat([
        Observable.just(Mutation.validatePassword(input)),
        Observable.just(Mutation.validatePasswordCheck(currentState.passwordcheck ?? ""))
      ])
    case let .passwordCheckInput(input):
      return Observable.just(Mutation.validatePasswordCheck(input))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
      
    case let .validateEmail(input):
      state.emailMessage = self.isValidEmail(input: input)
      return state
      
    case let .validateNickname(input):
      state.nickNameMessage = self.isValidNickname(input: input)
      return state
      
    case let .validatePassword(input):
      state.passwordMessage = self.isValidPassword(input: input)
      state.password = input
      return state
      
    case let .validatePasswordCheck(input):
      state.passwordCheckMessage = isValidPasswordCheck(input: input, pwd: state.password ?? "")
      state.passwordcheck = input
      return state
    }
  }
}

// MARK: - Method

/// email 입력값 확인해서 message 출력
private extension SNSSignInViewReactor {
  func isValidEmail(input: String) -> NSAttributedString {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    var message: NSAttributedString
    
    if input.isEmpty {
      message = NSAttributedString(string: "")
    } else if emailTest.evaluate(with: input) == false {
      message = NSAttributedString(
        string: "eamil 형식으로 입력해주세요",
        attributes: [.foregroundColor: UIColor.systemRed]
      )
    } else {
      message = NSAttributedString(
        string: "사용가능한 email 입니다.",
        attributes: [.foregroundColor: UIColor.systemGray]
      )
    }
    return message
  }
  
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
        string: "8자 이하 올바른 형식으로 입력해주세요.",
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
  
  func isValidPassword(input: String) -> NSAttributedString {
    var message: NSAttributedString?
    if input.count == 0 {
      message = NSAttributedString(string: "")
    } else if input.count > 0 && input.count < 6 {
      message = NSAttributedString(
        string: "6자리 이상 입력해주세요",
        attributes: [.foregroundColor: UIColor.systemRed]
      )
    } else if input.count >= 6 {
      message = NSAttributedString(
        string: "사용가능한 비밀번호입니다.",
        attributes: [.foregroundColor: UIColor.systemGray]
      )
    }
    return message ?? NSAttributedString(string: "")
  }
  
  func isValidPasswordCheck(input: String, pwd: String) -> NSAttributedString {
    var message: NSAttributedString?
    
    if input.count == 0 {
      message = NSAttributedString(string: "")
    } else if input != pwd {
      message = NSAttributedString(
        string: "비밀번호와 일치하지 않습니다.",
        attributes: [.foregroundColor: UIColor.systemRed]
      )
    } else {
      message = NSAttributedString(
        string: "비밀번호와 일치합니다.",
        attributes: [.foregroundColor: UIColor.systemGray]
      )
    }
    return message ?? NSAttributedString(string: "")
  }
}
