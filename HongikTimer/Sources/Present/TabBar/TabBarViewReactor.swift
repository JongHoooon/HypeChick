//
//  TabBarViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/01.
//

import UIKit

final class TabBarViewReactor {
   
  let provider: ServiceProviderType
  var user: User
  
  init(_ provider: ServiceProviderType, with user: User) {
    self.provider = provider
    self.user = user
  }
  
  private let homeTabBarItem = UITabBarItem(
    title: nil,
    image: UIImage(systemName: "house"),
    selectedImage: UIImage(systemName: "house.fill")
  )
  private let todoTabBarItem = UITabBarItem(
    title: nil,
    image: UIImage(systemName: "checklist"),
    selectedImage: UIImage(systemName: "checklist")
  )
  private let timerTabBarItem = UITabBarItem(
    title: nil,
    image: UIImage(systemName: "timer"),
    selectedImage: UIImage(systemName: "timer")
  )
  private let groupTabBarItem = UITabBarItem(
    title: nil,
    image: UIImage(systemName: "person.3"),
    selectedImage: UIImage(systemName: "person.3.fill")
  )
  private let boardTabBarItem = UITabBarItem(
    title: nil,
    image: UIImage(systemName: "list.bullet.rectangle"),
    selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
  )
  
  private lazy var homeViewConroller = UINavigationController(
    rootViewController: HomeViewController(
      HomeViewReactor(self.provider, with: self.user)
    )).then {
      $0.tabBarItem = homeTabBarItem
    }
  
  private lazy var todoViewController = UINavigationController(rootViewController: TodoViewController(
    TodoViewReactor(self.provider, user: self.user)
  )).then {
    $0.tabBarItem = todoTabBarItem
  }
  
  private lazy var timerViewController = UINavigationController(
    rootViewController: TimerViewController(
      TimerViewReactor(self.provider, with: self.user)
    )).then {
    $0.tabBarItem = timerTabBarItem
  }
  
  private lazy var groupViewController = UINavigationController(rootViewController: GroupDetailViewController()).then {
    $0.tabBarItem = groupTabBarItem
  }
  private lazy var boardViewController = UINavigationController(rootViewController: BoardViewController(
    BoardViewReactor(self.provider, with: self.user)
  )).then {
    $0.tabBarItem = boardTabBarItem
  }

  lazy var viewControllers = [
    homeViewConroller,
    todoViewController,
    timerViewController,
    groupViewController,
    boardViewController
  ]
}
