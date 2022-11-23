//
//  BoardViewController.swift
//  10-2-home
//
//  Created by JongHoon on 2022/10/14.
//

import UIKit

import ReactorKit
import RxDataSources
import RxViewController
import Then
import SnapKit
import Toast_Swift

class BoardViewController: BaseViewController, View {
  
  // MARK: - Property
  
  let dataSource = RxCollectionViewSectionedReloadDataSource<BoardListSection>(
    configureCell: { _, collectionView, indexPath, reactor in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: BoardViewCell.identifier,
        for: indexPath
      ) as? BoardViewCell
      cell?.reactor = reactor
      
      return cell ?? UICollectionViewCell()
    }, configureSupplementaryView: { _, collectionView, _, indexPath in
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: BoardCollectionHeaderView.identifier,
        for: indexPath
      ) as? BoardCollectionHeaderView
      
      return header ?? UICollectionReusableView()
    }
  )
  
  // MARK: - UI
  
  private lazy var refreshControl = UIRefreshControl().then {
    $0.attributedTitle = NSAttributedString(
      string: "🐥당겨서 새로 고침!🐣",
      attributes: [.foregroundColor: UIColor.label]
    )
  }
  
  private lazy var boardCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = UICollectionViewFlowLayout()
    
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
    
    $0.refreshControl = refreshControl
    
    $0.register(
      BoardViewCell.self,
      forCellWithReuseIdentifier: BoardViewCell.identifier
    )
    
    $0.register(
      BoardCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: BoardCollectionHeaderView.identifier
    )
    
    $0.backgroundColor = .systemGray6
  }
  
  private lazy var writeButton = UIButton().then {
    let plusImage = UIImage(systemName: "plus")?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal)
    $0.setImage(plusImage, for: .normal)
//    $0.backgroundColor = .defaultTintColor
    $0.layer.cornerRadius = 28.0
    
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.masksToBounds = false
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowRadius = 4
    $0.layer.shadowOpacity = 0.4
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBar()
    configureLayout()
  }
  
  // MARK: - Initialize
  
  init(_ reactor: BoardViewReactor) {
    super.init()
    
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Binding
  
  func bind(reactor: BoardViewReactor) {
        
    // Action
    self.rx.viewDidAppear
      .map { _ in Reactor.Action.viewDidAppear }
      .bind(to: reactor.action )
      .disposed(by: self.disposeBag)
    
    boardCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
      .map { _ in Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.writeButton.rx.tap
      .map(reactor.reactorForWriteView)
      .subscribe(onNext: { [weak self] writeViewReactor in
        guard let self = self else { return }
        
        if self.reactor?.currentState.writeButtonEnable == true {
          
          let viewController = WriteViewController(writeViewReactor)
          let navigationViewController = UINavigationController(rootViewController: viewController)
          navigationViewController.modalPresentationStyle = .fullScreen
          self.present(navigationViewController, animated: true)
        } else {
          self.view.makeToast("이미 가입한 그룹이 있습니다.", position: .top)
        }
      })
      .disposed(by: self.disposeBag)
    
    self.boardCollectionView.rx.modelSelected(BoardListSection.Item.self)
      .subscribe(onNext: { [weak self] boardPostReactor in
        let club = boardPostReactor.currentState.club
        
        guard let self = self else { return }
        guard let reactor = self.reactor?.reactorForEnterView() else { return }
        reactor.initialState.club = club
        let viewcontroller = EnterViewController(reactor: reactor)
        
        self.navigationController?.pushViewController(viewcontroller, animated: true)
      })
      .disposed(by: disposeBag)
    
    // State
    reactor.state.asObservable().map { $0.sections }
      .bind(to: self.boardCollectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
    
    reactor.state.asObservable().map { $0.writeButtonEnable }
      .subscribe(onNext: { [weak self] enable in
        
        if enable == true {
          self?.writeButton.backgroundColor = .defaultTintColor
        } else {
          self?.writeButton.backgroundColor = .systemGray2
        }
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse(\.$endRefreshing)
      .subscribe(onNext: { [weak self] _ in
        self?.refreshControl.endRefreshing()
      })
      .disposed(by: self.disposeBag)
    
    // delegate
    self.boardCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

// MARK: - Private

private extension BoardViewController {
  
  func configureTabBar() {
    
    let titleLabel = UILabel().then {
      $0.text = "Chick🔥👨‍💻"
      $0.font = .systemFont(ofSize: 16.0, weight: .bold)
    }
    let leftItem = UIBarButtonItem(customView: titleLabel)
    
    navigationItem.leftBarButtonItem = leftItem
  }
  
  func configureLayout() {
    [
      boardCollectionView,
      writeButton
    ].forEach { view.addSubview($0) }
    
    boardCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    writeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16.0)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8.0)
      $0.height.width.equalTo(56.0)
    }
  }
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 16.0, height: 160.0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: view.frame.width, height: 32.0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: 4.0, left: 8.0,
      bottom: 4.0, right: 8.0
    )
  }
}

// MARK: - Private

private extension BoardViewController {
  
  // MARK: - Selector
  
  @objc func refresh() {
    refreshControl.endRefreshing()
  }
}
