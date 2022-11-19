//
//  EmailSignInReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/09.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

final class EmailSignInReactor: Reactor {
  
  let provider: ServiceProviderType
  
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
    
    case registerButtonIsEnable
  }
  
  struct State {
    var emailMessage: NSAttributedString?
    var nickNameMessage: NSAttributedString?
    var passwordMessage: NSAttributedString?
    var passwordCheckMessage: NSAttributedString?
    var password: String?
    var passwordcheck: String?
    
    var isValidEmail: Bool = false
    var isValidNickName: Bool = false
    var isValidPassword: Bool = false
    var isValidPasswordCheckMessage: Bool = false
    
    var registerButtonIsEnable: Bool = false
  }
    
  var initialState: State = State()
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    case let .emailInput(input):
      return .concat([
        .just(Mutation.validateEmail(input)),
        .just(Mutation.registerButtonIsEnable)
      ])
      
    case let .nicknameInput(input):
      return .concat([
        .just(Mutation.validateNickname(input)),
        .just(Mutation.registerButtonIsEnable)
      ])
      
    case let .passwordInput(input):
      return Observable.concat([
        .just(Mutation.validatePassword(input)),
        .just(Mutation.validatePasswordCheck(currentState.passwordcheck ?? "")),
        .just(Mutation.registerButtonIsEnable)
      ])
    case let .passwordCheckInput(input):
      return .concat([
        .just(Mutation.validatePasswordCheck(input)),
        .just(Mutation.registerButtonIsEnable)
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
      
    case let .validateEmail(input):
      self.isValidEmail(input: input) { message, isValid in
        state.emailMessage = message
        state.isValidEmail = isValid
        
      }
          
    case let .validateNickname(input):
      self.isValidNickname(input: input) { message, isValid in
        state.nickNameMessage = message
        state.isValidNickName = isValid
      }
      
    case let .validatePassword(input):
      state.password = input
      self.isValidPassword(input: input) { message, isValid in
        state.passwordMessage = message
        state.isValidPassword = isValid
      }
      
    case let .validatePasswordCheck(input):
      state.passwordcheck = input
      self.isValidPasswordCheck(input: input, pwd: state.password ?? "") { message, isValid in
        state.passwordCheckMessage = message
        state.isValidPasswordCheckMessage = isValid
      }
      
    case .registerButtonIsEnable:
      if state.isValidEmail == true &&
          state.isValidNickName == true &&
          state.isValidPassword == true &&
          state.isValidPasswordCheckMessage == true {
        state.registerButtonIsEnable = true
      } else {
        state.registerButtonIsEnable = false
      }
    }
    
    return state
  }
}

// MARK: - Method

/// email 입력값 확인해서 message 출력
private extension EmailSignInReactor {
  func isValidEmail(
    input: String,
    completion: (_ message: NSAttributedString, _ isValid: Bool
    ) -> Void) {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    var message: NSAttributedString
    var isValid: Bool = false
    
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
      isValid = true
    }
    
    completion(message, isValid)
  }
  
  func isValidNickname(
    input: String,
    completion: (_ message: NSAttributedString, _ isValid: Bool
    ) -> Void) {
    
    let nicknameRegEx = "[가-힣A-Za-z0-9]{2,8}"
    let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
    var message: NSAttributedString
    var isValid: Bool = false
    
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
      isValid = true
    }
    
    completion(message, isValid)
  }
  
  func isValidPassword(input: String, completion: (_ message: NSAttributedString, _ isValid: Bool) -> Void) {
    var message: NSAttributedString?
    var isValid: Bool = false
    
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
      isValid = true
    }
    
    completion(message ?? NSAttributedString(string: ""), isValid)
  }
  
  func isValidPasswordCheck(input: String, pwd: String, completion: (_ message: NSAttributedString, _ isValid: Bool) -> Void) {
    var message: NSAttributedString?
    var isValid: Bool = false

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
      isValid = true
    }
  
    completion(message ?? NSAttributedString(string: ""), isValid)
  }
}
