//
//  ObservableType+Extension.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/01.
//

import RxSwift
import UIKit

extension Observable {
  public func unwrap<Result>() -> Observable<Result> where Element == Result? {
    return self.compactMap { $0 }
  }
}

