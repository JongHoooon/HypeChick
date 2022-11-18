//
//  TodoService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/13.
//

import UIKit
import RxSwift

enum HeaderEvent {
  case create
}

enum EditEvent {
  case delete
  case edit
  case check
}

final class TodoService {
  
  let userDefaultservice = UserDefaultService.shared
  
  let headerEvent = PublishSubject<HeaderEvent>()
  let editEvent = PublishSubject<EditEvent>()
  
  func fetchTask() -> Observable<[Task]> {
    if let savedTasks = userDefaultservice.getTasks() {
      return .just(savedTasks)
    }
    #warning("더미")
    let defaultTasks: [Task] = [
      Task(contents: "스위프트 문법 공부"), Task(contents: "운영체제 2주차 복습"), Task(contents: "코딩테스트 공부")
    ]
    self.userDefaultservice.setTasks(defaultTasks)
    return .just(defaultTasks)
  }
  
  @discardableResult
  func saveTasks(_ tasks: [Task]) -> Observable<Void> {
    self.userDefaultservice.setTasks(tasks)
    return .just(Void())
  }
  
  func create(contents: String) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let self = self else { return .empty() }
        let newTask = Task(contents: contents)
        return self.saveTasks(tasks + [newTask]).map { newTask }
      }
  }
  
  // MARK: - Header Event
  func tapCreateButton() -> Observable<Void> {
    self.headerEvent.onNext(.create)
    return .empty()
  }
  
  // MARK: - Edit Event
  func tapEditButton() -> Observable<Bool> {
    self.editEvent.onNext(.edit)
    return .just(true)
  }
  
  func tapDeleteButton() -> Observable<Bool> {
    self.editEvent.onNext(.delete)
    return .just(true)
  }
  
  func tapCheckButton() -> Observable<Bool> {
    self.editEvent.onNext(.check)
    return .just(true)
  }
}
