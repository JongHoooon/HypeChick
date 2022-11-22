//
//  HomeViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit
import ReactorKit
import Alamofire
import RxViewController
import RxAlamofire
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
  
  let reactor: HomeViewReactor
  
  var purpose: String? = "탭하여 목표를 입력하세요!" {
    didSet {
      purposeView.setPurpose(with: purpose ?? "")
    }
  }
  
  private lazy var wallpaperImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var chickImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var timeLabel = UILabel().then {
    $0.text = "00:00:00"
    $0.font = UIFont(name: "NotoSansCJKkr-Medium", size: 52.0)
  }
  
  private lazy var purposeView = PurposeView(purpose: purpose ?? "").then {
    let tap = UITapGestureRecognizer(
      target: self,
      action: #selector(tapPurposeView)
    )
    $0.addGestureRecognizer(tap)
    $0.isUserInteractionEnabled = true
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationbar()
    setupLayout()
    bind(reactor: self.reactor)
    
//    UserDefaultService.shared.logoutUser()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    refresh()
    reloadInputViews()
  }
  
  // MARK: - Init
  
  init(_ reactor: HomeViewReactor) {
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Bind

extension HomeViewController: View {
  func bind(reactor: HomeViewReactor) {
    
    // MARK: Action
    
    self.rx.viewDidLoad
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // MARK: State
    
    reactor.state.asObservable().map { $0.purposeText }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        
        if text?.isEmpty == true {
          self.purposeView.purposeLabel.text = "탭하여 목표를 입려하세요!"
        } else {
          self.purposeView.purposeLabel.text = text
        }
      })
      .disposed(by: self.disposeBag)
    
//    reactor.state.asObservable().map { $0.chickImage }
//      .bind(to: chickImageView.rx.image)
//      .disposed(by: self.disposeBag)
//
//    reactor.state.asObservable().map { $0.studyTime }
//      .bind(to: timeLabel.rx.text)
//      .disposed(by: self.disposeBag)
    
  }
}

// MARK: - Method

private extension HomeViewController {
  func setNavigationbar() {
    navigationItem.title = "Home"
    
    let settingBarButton = UIBarButtonItem(
      image: UIImage(systemName: "gearshape"),
      style: .plain,
      target: self,
      action: #selector(tapSettingButton)
    )
    
    navigationItem.leftBarButtonItem = settingBarButton
    
    let notificationBarButton = UIBarButtonItem(
      image: UIImage(systemName: "bell"),
      style: .plain,
      target: self,
      action: #selector(tapNotificationButton)
    )
    
    let itemBarButton = UIBarButtonItem(
      image: UIImage(systemName: "paintpalette"),
      style: .plain,
      target: self,
      action: #selector(tapItemButton)
    )
    
    navigationItem.rightBarButtonItems = [itemBarButton, notificationBarButton]
  }
  
  func setupLayout() {
    [
      wallpaperImageView,
      purposeView,
      chickImageView,
      timeLabel
    ].forEach { view.addSubview($0) }
    
    wallpaperImageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaInsets)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.snp_bottomMargin)
    }
    
    purposeView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
      $0.leading.trailing.equalToSuperview().inset(32.0)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(100.0)
    }
    
    chickImageView.snp.makeConstraints {
      $0.top.equalTo(purposeView.snp.bottom).offset(36.0)
      $0.width.height.equalTo(240.0)
      $0.centerX.equalToSuperview()
    }
    
    timeLabel.snp.makeConstraints {
      $0.top.equalTo(chickImageView.snp.bottom).offset(36.0)
      $0.centerX.equalToSuperview()
    }
  }
  
  func refresh() {
    
    chickImageView.image = reactor.provider.userDefaultService.getChickImage()
    wallpaperImageView.image = reactor.provider.userDefaultService.getWallImage()
    
    let urlRequest = TimerRouter.getTodayTime
    request(urlRequest)
      .validate(statusCode: 200..<500)
      .responseJSON()
      .map { dataResponse -> Int in

        guard let data = dataResponse.data else {
          print("DEBUG 시간 불러오기 실패")
          return 0 }
        guard let timerResponse = try? JSONDecoder().decode(TimerResponse.self, from: data) else { return 0 }
        guard let time = timerResponse.time else { return 0 }

        return time
      }
      .bind(to: self.timeLabel.rx.intToTimerFormat)
      .disposed(by: self.disposeBag)
    
  }
  
  // MARK: - Selector
  
  @objc func tapPurposeView() {
    let vc = SetPurposeViewController(
      reactor: SetPurposeViewReactor(provider: reactor.provider,
                                     userInfo: reactor.userInfo))
    vc.textCompletion = { purpose in
      self.purpose = purpose
    }
    
    let nv = UINavigationController(rootViewController: vc)
    nv.modalPresentationStyle = .overCurrentContext
    present(nv, animated: true)
  }
  
  @objc func tapSettingButton() {
    let vc = SettingViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func tapNotificationButton() {
    let vc = NotificationViewController(
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func tapItemButton() {
    let vc = ItemViewController(ItemViewReactor(reactor.provider, with: reactor.userInfo))
    navigationController?.pushViewController(vc, animated: true)
  }
}
