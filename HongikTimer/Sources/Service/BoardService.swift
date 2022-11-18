//
//  BoardService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/06.
//

import RxSwift

/// Board Service 관련 이벤트
enum BoardEvent {
  case create(BoardPost)
}

protocol BoardServicType {
  
  var event: PublishSubject<BoardEvent> { get }
  func fetchBoardPosts() -> Observable<[BoardPost]>
  
  @discardableResult
  func saveBoardPosts(_ boarPosts: [BoardPost]) -> Observable<Void>
  
  func create(
    _ title: String,
    maxMemberCount: Int,
    chief: String,
    startDay: Date,
    content: String
  ) -> Observable<BoardPost>
}

final class BoardService: BoardServicType {
  
  let userDefaultservice = UserDefaultService.shared
  let event = PublishSubject<BoardEvent>()

  func fetchBoardPosts() -> Observable<[BoardPost]> {
    if let savedBoardPosts = userDefaultservice.getBoardPosts() {
      return .just(savedBoardPosts)
    }
    
    let defaultPosts: [BoardPost] = [
      BoardPost(title: "코딩테스트 알고리즘 스터디",
                memberCount: 2,
                maxMemberCount: 4,
                chief: "김상수",
                startDay: Date(),
                content: "안녕하세요 저는 스타트업에서 1년정도 일을 하다가 이직을 위해 퇴사를 하고 이직을 준비하고 있는 웹 프론트엔드 개발자입니다.몇몇 괜찮은 기업 채용 과정에서 코테에서 떨어지는 경우가 많아 좀 더 체계적으로 코테를 준비해보려 합니다. 아래의 내용을 읽고 저와 마음이 맞을 것 같으신 분들은 맨 아래에 적혀있는 이메일 혹은 카카오톡으로 연락 바랍니다. ☺️사람을 구하기 이전에 제가 어떤 사람인지 먼저 소개가 필요할 것 같아 저의 깃헙 주소와 블로그 주소를 첨부합니다."),
      
      BoardPost(title: "목요일 22시 온라인 클라우드 네이티브 자바 스터디 모집",
                maxMemberCount: 3,
                chief: "Endend",
                startDay: Date(),
                content: "안녕하세요. 클라우드 네이티브 자바 책 스터디 참여 희망자를 모집합니다. \n 매주 1챕터씩 목요일 22시에 진행됩니다. \n 아주 초보는 하시기 어렵고, 이론적인 내용이 많은 관심이 있으신 분은 구글 설문지에 작성을 부탁드립니다. 댓글을 일일이 확인하지는 않습니다. \n 11/23일까지 모집하고, 피드백을 드리겠습니다."),
      
    BoardPost(title: "ios 스위프트 스터디하실분~",
              maxMemberCount: 4,
              chief: "deft333",
              startDay: Date(),
              content: "안녕하세요 \n 회사에서 ios를 구축하게 될거같아 스터디하면서 해보실분 모집합니다 \n rn을 주로 사용하여 간접적으로 ios는 사용해봤지만 \n 순수 ios는 이번이 처음입니다 \n 요일은 주중 하루 생각하는데 협의하면 될거같습니다 \n 지역은 강남 또는 구로구 생각하구있어요"),
      
      BoardPost(title: "파이썬 알고리즘 코딩테스트 스터디",
                memberCount: 2,
                maxMemberCount: 4,
                chief: "김상수",
                startDay: Date(),
                content: "안녕하세요 저는 스타트업에서 1년정도 일을 하다가 이직을 위해 퇴사를 하고 이직을 준비하고 있는 웹 프론트엔드 개발자입니다.몇몇 괜찮은 기업 채용 과정에서 코테에서 떨어지는 경우가 많아 좀 더 체계적으로 코테를 준비해보려 합니다. 아래의 내용을 읽고 저와 마음이 맞을 것 같으신 분들은 맨 아래에 적혀있는 이메일 혹은 카카오톡으로 연락 바랍니다. ☺️사람을 구하기 이전에 제가 어떤 사람인지 먼저 소개가 필요할 것 같아 저의 깃헙 주소와 블로그 주소를 첨부합니다."),
                
    ]
    self.userDefaultservice.setBoardPost(defaultPosts)
    return .just(defaultPosts)
  }
  
  @discardableResult
  func saveBoardPosts(_ boarPosts: [BoardPost]) -> Observable<Void> {
    userDefaultservice.setBoardPost(boarPosts)
    return .just(Void())
  }
  
  func create(
    _ title: String,
    maxMemberCount: Int,
    chief: String,
    startDay: Date,
    content: String
  ) -> Observable<BoardPost> {
    return self.fetchBoardPosts()
      .flatMap { [weak self] boardPosts -> Observable<BoardPost> in
        guard let self = self else { return .empty() }
        let newPost = BoardPost(
          title: title,
          maxMemberCount: maxMemberCount,
          chief: chief,
          startDay: startDay,
          content: content
        )
        return self.saveBoardPosts([newPost] + boardPosts).map { _ in newPost }
      }
      .do(onNext: { boardPost in
        self.event.onNext(.create(boardPost))
      })
  }
}
