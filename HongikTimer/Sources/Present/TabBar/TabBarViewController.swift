//
//  TabBarViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import FirebaseAuth
import UIKit
import SwiftUI

final class TabBarViewController: UITabBarController {
  
  // MARK: - Property
  
  let reactor: TabBarViewReactor
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabBar()
  }
  
  // MARK: - Init
  
  init(with reactor: TabBarViewReactor) {
    self.reactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Method

private extension TabBarViewController {
  
  func setTabBar() {
    viewControllers = reactor.viewControllers
    tabBar.backgroundColor = .systemGray6
  }
}

// MARK: - TabBarItem
 
