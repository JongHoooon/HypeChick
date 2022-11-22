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
  
  // MARK: - Timer
  
  //  func getTime() -> Observable<Result<Int,ApiError>> {
  //
  //    let urlRequest = TimerRouter.getTodayTime
  //    request(urlRequest)
  //      .responseJSON()
  //      .map { dataResponse ->}
  //
  //  }
  
  // MARK: - Todo
  
  func getTasks() -> Observable<[Todo]> {
    
    return Observable<[Todo]>.create { observer in
      let urlRequest = TodoRouter.getTasks
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          
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
        })
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
        .subscribe(onNext: { dataResponse in
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
        })
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
      .subscribe(onNext: { dataResponse in
        switch dataResponse.result {
        case .success:
          print("DEBUG todo contents 수정 완료")
          
        case .failure(let error):
          APIClient.handleError(.unknown(error))
          
        }
      })
      .disposed(by: self.disposebag)
  }
  
  func deleteTodo(taskId: Int) {
    let todoDeleteRequest = TodoDeleteRequest(taskId: taskId)
    let urlRequest = TodoRouter.deleteTodo(todoDeleteRequest)
    
    request(urlRequest)
      .validate(statusCode: 200..<300)
      .responseJSON()
      .subscribe(onNext: { dataResponse in
        switch dataResponse.result {
        case .success:
          print("DEBUG todo contents 삭제 완료")
          
        case .failure(let error):
          APIClient.handleError(.unknown(error))
          
        }
      })
      .disposed(by: self.disposebag)
  }
  
  func checkTodo(taskId: Int) {
    let todoCheckRequest = TodoCheckRequest(taskId: taskId)
    let urlRequest = TodoRouter.checkTodo(todoCheckRequest)
    
    request(urlRequest)
      .validate(statusCode: 200..<300)
      .responseJSON()
      .subscribe(onNext: { dataResponse in
        switch dataResponse.result {
        case .success:
          print("DEBUG todo check toggle 완료")
          
        case .failure(let error):
          APIClient.handleError(.unknown(error))
        }
      })
      .disposed(by: self.disposebag)
  }
  
  // MARK: - Board 화면
  
  /// 전체 그룹 조회 - 게시판에 표시
  func getClubs() -> Observable<Result<[Club], ApiError>> {
    
    return Observable<Result<[Club], ApiError>>.create { observer in
      let urlRequest = GroupRouter.getClubs
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          
          switch dataResponse.result {
          case .success:
            guard let data = dataResponse.data else { return }
            guard let clubsResponse = try? JSONDecoder().decode(ClubsResponse.self, from: data) else { return }
            guard let clubs = clubsResponse.data else { return }
            observer.onNext(.success(clubs))
            
          case .failure(let error):
            observer.onNext(.failure(ApiError.unknown(error)))
          }
          observer.onCompleted()
        })
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
  
  func createClub(id: Int, clubName: String, numOfMember: Int, clubInfo: String) {
    
    let createClubRequest = CreateClubRequest(memberID: id,
                                              clubName: clubName,
                                              numOfMember: numOfMember,
                                              clubInfo: clubInfo)
    let urlRequest = GroupRouter.createClub(createClubRequest)
    
    request(urlRequest)
      .validate(statusCode: 200..<300)
      .responseJSON()
      .subscribe(onNext: { dataResponse in
        switch dataResponse.result {
        case .success(let data):
          print("DEBUG 그룹 생성 성공!")
          guard let data = data as? [String: Any] else { return }
          guard let id = data["clubId"] as? Int else { return }
          guard var user: User = UserDefaultService.shared.getUser() else { return }
          user.userInfo.clubID = id
          UserDefaultService.shared.setUser(user)
        case .failure(let error):
          APIClient.handleError(.unknown(error))
        }
      })
      .disposed(by: self.disposebag)
  }
  
  func signInClub(clubID: Int, memberID: Int) -> Observable<Result<Int, ApiError>> {
    
    return Observable<Result<Int, ApiError>>.create { observer in
      let signInClubRequest = SignInClubRequest(clubID: clubID, memberID: memberID)
      let urlRequest = GroupRouter.signInClub(signInClubRequest)
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          switch dataResponse.result {
          case let .success(data):
            guard let data = data as? [String: Any] else { return }
            guard let clubId = data["clubId"] as? Int else { return }
            observer.onNext(.success(clubId))
            print("DEBUG 클럽ID: \(clubId) 가입 성공")
            
          case let .failure(error):
            APIClient.handleError(.unknown(error))
            observer.onNext(.failure(ApiError.unknown(error)))
            print("DEBUG 클럽 가입 실패")
          }
          observer.onCompleted()
        })
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
  
  // MARK: - Group 화면
  
  func getClub(clubID: Int) -> Observable<Result<GetClubResponse, ApiError>> {
    
    return Observable<Result<GetClubResponse, ApiError>>.create { observer in
      let clubGetReqeust = ClubGetRequest(clubID: clubID)
      let urlRequest = GroupRouter.getClub(clubGetReqeust)
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          switch dataResponse.result {
          case .success:
            print("DEBUG 그룹 \(clubID) 호출 성공!")
            guard let data = dataResponse.data else { return }
            guard let getClubResponse = try? JSONDecoder().decode(GetClubResponse.self,
                                                                  from: data) else { return }
            print(getClubResponse)
            observer.onNext(.success(getClubResponse))
            
          case let .failure(error):
            print("DEBUG 그룹 \(clubID) 호출 실패")
            observer.onNext(.failure(.unknown(error)))
          }
          observer.onCompleted()
        })
        .disposed(by: self.disposebag)
      return Disposables.create()
    }
  }
  
  func editClub(clubName: String, clubInfo: String, clubID: Int) -> Observable<Result<Void, ApiError>> {
    
    return Observable.create { observer in
      let editClubInfoRequest = EditClubInfoRequest(clubName: clubName,
                                                    clubInfo: clubInfo,
                                                    clubID: clubID)
      let urlRequest = GroupRouter.editClub(editClubInfoRequest)
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          switch dataResponse.result {
          case .success:
            print("DEBUG 그룹 정보 수정 완료")
            observer.onNext(.success(Void()))
            
          case let .failure(error):
            APIClient.handleError(.unknown(error))
            observer.onNext(.failure(ApiError.unknown(error)))
          }
          observer.onCompleted()
        })
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
  
  func deleteClub(clubID: Int) -> Observable<Result<Int, ApiError>> {
    
    return Observable.create { observer in
      let deleteClubRequest = DeleteClubRequest(clubID: clubID)
      let urlRequest = GroupRouter.deleteClub(deleteClubRequest)
      
      request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseJSON()
        .subscribe(onNext: { dataResponse in
          switch dataResponse.result {
          case .success:
            print("DEBBUG 그룹 삭제 성공")
            observer.onNext(.success(clubID))
          case let .failure(error):
            print("DEBUG 그룹 삭제 실패")
            APIClient.handleError(.unknown(error))
            observer.onNext(.failure(ApiError.unknown(error)))
          }
          observer.onCompleted()
        })
        .disposed(by: self.disposebag)
      
      return Disposables.create()
    }
  }
}
