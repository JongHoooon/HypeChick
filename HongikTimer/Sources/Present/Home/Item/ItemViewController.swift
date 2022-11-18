//
//  ItemViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit
import ReactorKit

final class ItemViewController: BaseViewController {
  
  // MARK: - Property
  
  let categories: [ItemCell] = [
    ItemCell("벽지", imageName: "w8"),
    ItemCell("버드", imageName: "chick1")
  ]
  
  let reactor: ItemViewReactor
  
  private lazy var previewView = PreviewView().then {
    $0.layer.cornerRadius = 12.0
    $0.clipsToBounds = true
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = UICollectionViewFlowLayout()
    
    //      $0.alwaysBounceVertical = true
    $0.collectionViewLayout = layout
    $0.backgroundColor = .systemBackground
    $0.delegate = self
    $0.dataSource = self
    $0.register(
      ItemCollectionViewCell.self,
      forCellWithReuseIdentifier: ItemCollectionViewCell.identifier
    )
    $0.backgroundColor = .systemGray6
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationbar()
    configureLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    refresh()
    reloadInputViews()
  }
  
  // MARK: - Init
  
  init(_ reactor: ItemViewReactor) {
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Bind

extension ItemViewController: View {
  func bind(reactor: ItemViewReactor) {
    
  }
}

// MARK: - Method

private extension ItemViewController {
  func configureNavigationbar() {
    navigationItem.title = "아이템"
    navigationController?.navigationBar.topItem?.title = ""
  }
  
  func configureLayout() {
    view.backgroundColor = .systemGray6
    [
      previewView,
      collectionView
    ].forEach { view.addSubview($0) }
    
    previewView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(32.0)
      $0.height.equalTo(320.0)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(previewView.snp.bottom).offset(32.0)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func refresh() {
    previewView.wallImageView.image = reactor.provider.userDefaultService.getWallImage()
    previewView.chickImageView.image = reactor.provider.userDefaultService.getChickImage()
  }
}

// MARK: - CollectionView

extension ItemViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    categories.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ItemCollectionViewCell.identifier,
      for: indexPath
    ) as? ItemCollectionViewCell
    
    cell?.configureCell(with: categories[indexPath.item])
    cell?.layer.cornerRadius = 8.0
    cell?.clipsToBounds = true
    return cell ?? UICollectionViewCell()
  }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width / 4.5, height: 96.0)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: 0,
      left: 2.0,
      bottom: 2.0,
      right: 2.0
    )
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    if indexPath.item == 0 {
      let vc = WallpaperViewController(WallpaperViewReactor(
        reactor.provider,
        with: reactor.user
      ))
      vc.dismissCompletion = { [weak self] in
        self?.refresh()
      }
      present(UINavigationController(
        rootViewController: vc),
              animated: true
      )
    } else {
      let vc = ChickViewController(ChickViewReactor(
        reactor.provider,
        with: reactor.user
      ))
      vc.dismissCompletion = { [weak self] in
        self?.refresh()
      }
      present(UINavigationController(
        rootViewController: vc),
              animated: true
      )
    }
  }
}
