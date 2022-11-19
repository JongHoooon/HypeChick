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

enum ValidationResult {
  case ok(_ message: String)
  case short(_ message: String)
  case wrongForm(_ message: String)
}

final class SNSSignInViewReactor: Reactor {
  
  enum Action {
    case nicknameInput(_ nickname: String)
//    case tapSignIn
  }
  
  enum Mutation {
    case validateNickname(String)
//    case singInSuccess
//    case singInFail
  }
  
  struct State {
    var validatedNickname = ValidationResult.short("")
    var username: String?
    var isSignIn: Bool = false
  }
    
  var initialState: State = State()
  let provider: ServiceProviderType
  let uid: String
  let kind: LoginKind
  let disposeBag = DisposeBag()
  
  init(provider: ServiceProviderType, uid: String, kind: LoginKind) {
    self.provider = provider
    self.uid = uid
    self.kind = kind
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .nicknameInput(input):
      return Observable.just(Mutation.validateNickname(input))
      
      //    case .tapSignIn:
    }
  }
  
    func reduce(state: State, mutation: Mutation) -> State {
      var state = state
      switch mutation {
        
      case let .validateNickname(input):
        
        self.validateNickname(input)
          .subscribe(onNext: {
            state.validatedNickname = $0
          })
          .disposed(by: self.disposeBag)
        state.username = input
        
      }
      
      return state
    }
}

// MARK: - Method

private extension SNSSignInViewReactor {
  
  /// email 입력값 확인해서 message 출력
  func validateNickname(_ nickname: String) -> Observable<ValidationResult> {
    let nicknameRegEx = "[가-힣A-Za-z0-9]{2,8}"
    let nicknameTest = NSPredicate(format: "SELF MATCHES %@", nicknameRegEx)
    
    if nickname.isEmpty {
      return .just(.short(""))
    } else if nickname.count == 1 {
      return .just(.short("2자 이상 올바른 형식으로 입력해주세요."))
    } else if nicknameTest.evaluate(with: nickname) == false {
      return .just(.wrongForm("특수 문자 없이 8자 이하로 입력해주세요."))
    } else {
      return .just(.ok("사용가능한 별명 입니다."))
    }
  }
}
