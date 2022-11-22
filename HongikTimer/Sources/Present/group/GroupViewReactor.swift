//
//  GroupViewReactor.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/22.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources

typealias GroupMembersSection = SectionModel<Void, GroupCellReactor>

final class GroupViewReactor: Reactor, BaseReactorType {
  
  enum Action {
    case viewWillAppear
    
    case deleteGroup
  }
  
  enum Mutation {
    case viewWillAppear
    case noGroup
    
    case setSections(groupID: Int?,
                     clubResponse: GetClubResponse?,
                     sections: [GroupMembersSection])
  }
  
  struct State {
    var groupID: Int?
    var isGroup: Bool = true
    
    var clubResponse: GetClubResponse?
    var sections: [GroupMembersSection]
  }
  
  let provider: ServiceProviderType
  let initialState: State
  
  init(provider: ServiceProviderType) {
    self.provider = provider
    
    initialState = State(sections: [])
  }
  
    func mutate(action: Action) -> Observable<Mutation> {
      
      switch action {
      
      case .viewWillAppear:
        
        if provider.userDefaultService.getUser()?.userInfo.clubID == nil {
          return .just(.noGroup)
        }
        
          return self.provider.apiService.getClub(clubID: provider.userDefaultService.getUser()?.userInfo.clubID ?? 0)
          .map { result in
            switch result {
            case let .success(getClubResponse):
              guard let members = getClubResponse.members?.data else { return .setSections(groupID: nil,
                                                                                           clubResponse: nil,
                                                                                           sections: []) }
              let sectionItems = members.map { GroupCellReactor.init(member: $0,
                                                                     provider: self.provider)}
              let section = GroupMembersSection(model: Void(),
                                                items: sectionItems)
              return .setSections(groupID: self.provider.userDefaultService.getUser()?.userInfo.clubID ?? 0,
                                  clubResponse: getClubResponse,
                                  sections: [section])
            case .failure:
              return .noGroup
            }
          }
        
      case .deleteGroup:
        guard var user = provider.userDefaultService.getUser() else { return .empty() }
        user.userInfo.clubID = nil
        provider.userDefaultService.setUser(user)
        
        return .just(.noGroup)
      }
    }
  
    func reduce(state: State, mutation: Mutation) -> State {
      var state = state
      switch mutation {
        
      // 유저 그룹ID 없는경우
      case .noGroup:
        state.groupID = nil
        state.isGroup = false
        state.clubResponse = nil
        state.sections = []
        
        print(state.isGroup)
      
      // 유저 그룹 ID 있는 경우
      case .viewWillAppear:
        state.groupID = provider.userDefaultService.getUser()?.userInfo.clubID
        state.isGroup = true
        print("그룹이 있습니다")
        
      // members section
      case let .setSections(groupID, clubResponse, sections):
        state.groupID = groupID
        state.isGroup = true
        
        state.clubResponse = clubResponse
        state.sections = sections
      }
      return state
    }
}
