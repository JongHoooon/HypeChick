//
//  BaseViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/30.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
  
  // MARK: - Property
  
  // MARK: Initializing

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }

  // MARK: Rx

  var disposeBag = DisposeBag()
  
}
