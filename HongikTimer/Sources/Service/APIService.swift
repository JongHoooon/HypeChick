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
            
            if todos.isEmpty {
              observer.onNext([Todo(), Todo(), Todo()])
            } else {
              observer.onNext(todos)
            }
            
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
}
