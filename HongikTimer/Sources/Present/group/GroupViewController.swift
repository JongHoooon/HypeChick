//
//  GroupViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import ReactorKit
import UIKit
import Then
import SnapKit
import RxCocoa
import RxDataSources
import CoreAudioTypes

final class GroupViewController: BaseViewController, View {
  
  // MARK: - Property
  
  let dataSource = RxCollectionViewSectionedReloadDataSource<GroupMembersSection> { _, collectionView, indexPath, reactor in
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.identifier,
                                                  for: indexPath) as? GroupCell
    
    cell?.reactor = reactor
    return cell ?? UICollectionViewCell()
  }
  
  let deleteGroupRelay = PublishRelay<Int>()
  
  // MARK: - UI
  
  private lazy var nilGroupView = NilGroupView(width: self.view.frame.width)
  
  private lazy var menuTabBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                      style: .plain,
                                                      target: self,
                                                      action: #selector(tapMenuButton))
  
  private lazy var titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20.0, weight: .bold)
    $0.textAlignment = .center
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  private lazy var purposeView = PurposePresentView().then {
    
    let tap = UITapGestureRecognizer(target: self,
                                     action: #selector(tapPresentView))
    $0.addGestureRecognizer(tap)
    $0.isUserInteractionEnabled = true
    
  }
  
  private lazy var groupDetailCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = UICollectionViewFlowLayout()
    
    //    layout.minimumInteritemSpacing = 4.0
    //    layout.minimumLineSpacing = 4.0
    
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
        
    $0.register(
      GroupCell.self,
      forCellWithReuseIdentifier: GroupCell.identifier
    )
    
  }
  
  private lazy var todayLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16.0, weight: .medium)
    $0.textColor = .black
    $0.numberOfLines = 1
    $0.text = "오늘 총 공부시간"
  }
  
  private lazy var totalTimeLabel = UILabel().then {
    $0.font = UIFont(name: "NotoSansCJKkr-Medium", size: 52.0)
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationBar()
    configureLayout()
  }
  
  // MARK: - init
  init(reactor: GroupViewReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Binding
  func bind(reactor: GroupViewReactor) {
    
    // action
    self.rx.viewWillAppear
      .map { _ in Reactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.deleteGroupRelay
      .map { _ in Reactor.Action.deleteGroup }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // state
    
    reactor.state.asObservable().map { $0.sections }
      .bind(to: self.groupDetailCollectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
    
    reactor.state.asObservable().map { $0.isGroup }
      .subscribe(onNext: { [weak self] isGroup in
        guard let self = self else { return }
        if !isGroup {
                    
          let vc = NilGroupViewController()
          self.navigationController?.pushViewController(vc, animated: true)
          
          self.menuTabBarButton.isEnabled = false
          
        } else {
          self.menuTabBarButton.isEnabled = true
        }
      })
      .disposed(by: self.disposeBag)
    
    reactor.state.asObservable().map {
      guard let clubResponse = $0.clubResponse else { return GetClubResponse() }
      return clubResponse
    }
    .subscribe(onNext: { [weak self] clubResponse in
      guard let self = self else { return }
      
      self.titleLabel.text = clubResponse.clubName ?? ""
      self.purposeView.purposeLabel.text = clubResponse.clubInfo ?? ""
      
      let sec = clubResponse.totalStudyTime ?? 0
      let time = sec
      let hour = time / 3600
      let miniute = (time % 3600) / 60
      let second = (time % 3600) % 60
      
      self.totalTimeLabel.text = String(
        format: "%02d:%02d:%02d",
        hour,
        miniute,
        second
      )
    })
    .disposed(by: self.disposeBag)
    
    // delegate
    
    groupDetailCollectionView.rx.setDelegate(self)
      .disposed(by: self.disposeBag)
  }
}

// MARK: - CollectionView

extension GroupViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    CGSize(width: view.frame.width / 2.5, height: 160)
  }
  
  //  func collectionView(
  //    _ collectionView: UICollectionView,
  //    layout collectionViewLayout: UICollectionViewLayout,
  //    minimumInteritemSpacingForSectionAt section: Int
  //  ) -> CGFloat {
  //    return 4.0
  //  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 4.0,
                        left: 32.0,
                        bottom: 4.0,
                        right: 32.0)
  }
}

// MARK: - Metod

extension GroupViewController {
  func configureNavigationBar() {
    navigationItem.title = "Group"
    
    navigationItem.rightBarButtonItem = menuTabBarButton
  }
  
  func configureLayout() {
    
    view.backgroundColor = .systemBackground
    
    [
      titleLabel,
      purposeView,
      groupDetailCollectionView,
      todayLabel,
      totalTimeLabel
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
    }
    
    purposeView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
      $0.height.equalTo(32.0)
      $0.leading.trailing.equalToSuperview()
    }
    
    groupDetailCollectionView.snp.makeConstraints {
      $0.top.equalTo(totalTimeLabel.snp.bottom).offset(16.0)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    todayLabel.snp.makeConstraints {
      $0.top.equalTo(purposeView.snp.bottom).offset(32.0)
      $0.centerX.equalToSuperview()
    }
    
    totalTimeLabel.snp.makeConstraints {
      $0.top.equalTo(todayLabel.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }
  
  // MARK: - Selector
  
  @objc func tapPresentView() {
    
    let vc = GroupDetailViewController(clubResponse: reactor!.currentState.clubResponse! )
    
    self.present(vc, animated: true)
  }
  
  @objc func tapMenuButton() {
    
    let confirmAlertController = UIAlertController(title: "그룹 삭제",
                                                   message: "정말로 그룹을 삭제하시겠습니까?",
                                                   preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "취소",
                                     style: .cancel)
    let confirmAction = UIAlertAction(title: "확인",
                                      style: .destructive) { [weak self] _ in
      guard let self = self else { return }
      self.reactor?.provider.apiService.deleteClub(clubID: self.reactor?.currentState.clubResponse?.id ?? 0)
        .subscribe(onNext: { result in
          switch result {
          case let .success(id):
            self.deleteGroupRelay.accept(id)
          case .failure:
            self.view.makeToast("그룹 삭제에 실패했습니다", position: .top)
          }
        })
        .disposed(by: self.disposeBag)
    }
    [
      confirmAction,
      cancelAction
    ].forEach { confirmAlertController.addAction($0) }
    
    if reactor?.provider.userDefaultService.getUser()?.userInfo.id == reactor?.currentState.clubResponse?.leaderId {
      let menuAlertController = UIAlertController(title: "그룹 수정 / 삭제",
                                                  message: nil,
                                                  preferredStyle: .actionSheet)
      
      let editAction = UIAlertAction(title: "수정",
                                     style: .default) { [weak self] _ in
        guard let self = self else { return }
        
        guard let provider = self.reactor?.provider else { return }
        guard let clubResponse = self.reactor?.currentState.clubResponse else { return }
        
        let vc = GroupEditViewController(
          GroupEditViewReactor(provider,
                               clubResponse: clubResponse))
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
      }
      
      let deleteAction = UIAlertAction(title: "삭제",
                                       style: .destructive) { _ in
        self.present(confirmAlertController,
                     animated: true)
      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel)
      [
        editAction,
        deleteAction,
        cancelAction
      ].forEach { menuAlertController.addAction($0) }
      self.present(menuAlertController, animated: true)
      
    } else {
      
      let confirmAlertController = UIAlertController(title: "그룹 탈퇴",
                                                     message: "정말로 그룹을 탈퇴하시겠습니까?",
                                                     preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "취소",
                                       style: .cancel)
      let confirmAction = UIAlertAction(title: "확인",
                                        style: .destructive) { [weak self] _ in
        guard let self = self else { return }
        guard let clubID = self.reactor?.currentState.clubResponse?.id else { return }
        
        self.reactor?.provider.apiService.leaveClub(clubID: clubID,
                                                    memberID: self.reactor?.provider.userDefaultService.getUser()?.userInfo.id ?? 0)
        
        self.deleteGroupRelay.accept(0)
      }
      [
        cancelAction,
        confirmAction
      ].forEach { confirmAlertController.addAction($0) }
      
      let leaveAlertController = UIAlertController(title: nil,
                                                   message: "그룹 탈퇴",
                                                   preferredStyle: .actionSheet)
      let leaveAction = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
        guard let self = self else { return }
        
        self.present(confirmAlertController, animated: true)
      }
      
      [
        cancelAction,
        leaveAction
      ].forEach { leaveAlertController.addAction($0) }
      self.present(leaveAlertController, animated: true)

    }
  }
}
