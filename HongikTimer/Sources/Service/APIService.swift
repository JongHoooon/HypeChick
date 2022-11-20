//
//  APIService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class APIService {

  let disposebag = DisposeBag()
  
  // MARK: - Todo
  
  func getTasks() -> Observable<[Todo]> {
    
    return Observable<[Todo]>.create { observer in
      let urlRequest = TodoRouter.getTasks
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .map { dataResponse in
          
          switch dataResponse.result {
          case .success:
            guard let data = dataResponse.data else { return }
            guard let todosResponse = try? JSONDecoder().decode(TodosResponse.self, from: data) else { return }
            guard let todos = todosResponse.data else { return }
            
            print("DEBUG \(todos) get 완료")
            
            observer.onNext(todos)
            
          case .failure(let error):
            observer.onError(error)
            APIClient.handleError(.unknown(error))
          }
          observer.onCompleted()
        }
        .subscribe()
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
  
  func createTodo(contents: String, date: Date) -> Observable<Task> {
    return Observable<Task>.create { observer in
      let todoPostRequest = TodoPostRequest(contents: contents, date: date)
      let urlRequest = TodoRouter.postTask(todoPostRequest)

      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .map { dataResponse in
          switch dataResponse.result {
          case .success:
            guard let data = dataResponse.data else { return }
            guard let todo = try? JSONDecoder().decode(Todo.self, from: data) else { return }
            let task = Task(todo: todo)
            observer.onNext(task)
            
          case .failure(let error):
            APIClient.handleError(.unknown(error))
            observer.onError(error)
          }
          observer.onCompleted()
        }
        .subscribe()
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
  
  func editTodo(contents: String, taskId: Int) {
      let todoContentsEditRequest = TodoContentsEditRequest(contents: contents, taskId: taskId)
      let urlRequest = TodoRouter.updateTodo(todoContentsEditRequest)

      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .map { dataResponse in
          switch dataResponse.result {
          case .success:
            print("DEBUG todo contents 수정 완료")

          case .failure(let error):
            APIClient.handleError(.unknown(error))
            
          }
        }
        .subscribe()
        .disposed(by: self.disposebag)
  }
  
  func deleteTodo(taskId: Int) {
      let todoDeleteRequest = TodoDeleteRequest(taskId: taskId)
      let urlRequest = TodoRouter.deleteTodo(todoDeleteRequest)

      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .map { dataResponse in
          switch dataResponse.result {
          case .success:
            print("DEBUG todo contents 삭제 완료")

          case .failure(let error):
            APIClient.handleError(.unknown(error))
            
          }
        }
        .subscribe()
        .disposed(by: self.disposebag)
  }
  
  func checkTodo(taskId: Int) {
    let todoCheckRequest = TodoCheckRequest(taskId: taskId)
    let urlRequest = TodoRouter.checkTodo(todoCheckRequest)
    
    request(urlRequest)
      .validate(statusCode: 200..<300)
      .responseJSON()
      .map { dataResponse in
        switch dataResponse.result {
        case .success:
          print("DEBUG todo check toggle 완료")

        case .failure(let error):
          APIClient.handleError(.unknown(error))
        }
      }
      .subscribe()
      .disposed(by: self.disposebag)
  }
}
