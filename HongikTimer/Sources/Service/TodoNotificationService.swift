//
//  TodoNotificationService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/11.
//

import UIKit

enum TodoState: String {
  case editTodo
  case removeTodo
  
  var notificationName: NSNotification.Name {
    return NSNotification.Name(rawValue: self.rawValue)
  }
}

enum TodoNotificationKey: String {
  case indexPath
}

struct TodoNotificationService {
  
  static let shared = TodoNotificationService()
  
  func postEdit(_ indexPath: IndexPath) {
    NotificationCenter.default.post(
      name: TodoState.editTodo.notificationName,
      object: nil,
      userInfo: [TodoNotificationKey.indexPath.rawValue: indexPath]
    )
  }
  
  func postRemove(_ indexPath: IndexPath) {
    NotificationCenter.default.post(
      name: TodoState.removeTodo.notificationName,
      object: nil,
      userInfo: [TodoNotificationKey.indexPath.rawValue: indexPath]
    )
  }
  
  func addObserverEdit(with view: UIView, completion: Selector) {
    NotificationCenter.default.addObserver(
      view,
      selector: completion,
      name: TodoState.editTodo.notificationName,
      object: nil
    )
  }
  
  func addObserverRemove(with view: UIView, completion: Selector) {
    NotificationCenter.default.addObserver(
      view,
      selector: completion,
      name: TodoState.removeTodo.notificationName,
      object: nil
    )
  }
}

