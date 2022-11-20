//
//  Reactive+Extension.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/01.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

/// SNSSignInViewController에서 버튼 활성화 판단할 때 사용
extension Reactive where Base: UIButton {
  var buttonValidate: Binder<ValidationResult> {
    return Binder(self.base) { button, validate in
      switch validate {
      case .ok:   button.isEnabled = true
      default:    button.isEnabled = false
      }
    }
  }
}

/// SNSSignInViewController에서 validation에 따라 message label text 설정
extension Reactive where Base: UILabel {
  var inputValidate: Binder<ValidationResult> {
    return Binder(self.base) { label, validate in
      switch validate {
      case .ok(let message):
        label.text = message
        label.textColor = .systemGray
      case .wrongForm(let message):
        label.text = message
        label.textColor = .systemRed
      case .short(let message):
        label.text = message
        label.textColor = .systemRed
      }
    }
  }
}

extension Reactive where Base: UILabel {
  var intToTimerFormat: Binder<Int> {
    return Binder(self.base) { label, sec in
      
      let time = sec
      let hour = time / 3600
      let miniute = (time % 3600) / 60
      let second = (time % 3600) % 60
      
      label.text = String(
        format: "%02d:%02d:%02d",
        hour,
        miniute,
        second
      )
    }
  }
}

/// WriteViewController에서 선택한 숫자에 따라 member label text 설정
extension Reactive where Base: UILabel {
  var selectedNumber: Binder<Int?> {
    return Binder(self.base) { label, number in
      switch number {
      case 1:
        label.text = "최대 1명"
      case 2:
        label.text = "최대 2명"
      case 3:
        label.text = "최대 3명"
      case 4:
        label.text = "최대 4명"
      default:
        label.text = "최대 인원수를 선택해 주세요."
      }
    }
  }
}
