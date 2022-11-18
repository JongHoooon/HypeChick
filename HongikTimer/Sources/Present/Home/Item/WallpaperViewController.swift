//
//  WallpaperViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit

final class WallpaperViewController: BaseViewController {
  
  // MARK: - Property

  let wallpapers: [ItemCell] = [
    ItemCell("벽지1", imageName: "w0"),
    ItemCell("벽지2", imageName: "w1"),
    ItemCell("벽지3", imageName: "w2"),
    ItemCell("벽지4", imageName: "w3"),
    ItemCell("벽지5", imageName: "w4"),
    ItemCell("벽지6", imageName: "w5"),
    ItemCell("벽지7", imageName: "w6"),
    ItemCell("벽지8", imageName: "w7"),
    ItemCell("벽지9", imageName: "w8")
  ]
  
  var dismissCompletion: (() -> Void)?

  let reactor: WallpaperViewReactor
  
  private lazy var previewView = PreviewView().then {
    $0.layer.cornerRadius = 12.0
    $0.clipsToBounds = true
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = UICollectionViewFlowLayout()
    
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
  
  init(_ reactor: WallpaperViewReactor) {
    self.reactor = reactor
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Method

private extension WallpaperViewController {
  
  func configureNavigationbar() {
//    navigationItem.title = "아이템"
//    navigationController?.navigationBar.topItem?.title = ""
    
    let rightBarButton = UIBarButtonItem(
      image: UIImage(systemName: "checkmark"),
      style: .plain,
      target: self,
      action: #selector(tabRightBarButton)
    )
    
    navigationItem.rightBarButtonItem = rightBarButton
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
  
  // MARK: - Selector
  
  @objc func tabRightBarButton() {
    self.dismiss(animated: true)
    dismissCompletion?()
  }
}

// MARK: - CollectionView

extension WallpaperViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    wallpapers.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ItemCollectionViewCell.identifier,
      for: indexPath
    ) as? ItemCollectionViewCell
    
    cell?.configureCell(with: wallpapers[indexPath.item])
    cell?.layer.cornerRadius = 8.0
    cell?.clipsToBounds = true
    return cell ?? UICollectionViewCell()
  }
}

extension WallpaperViewController: UICollectionViewDelegateFlowLayout {
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
      left: 4.0,
      bottom: 4.0,
      right: 4.0
    )
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let newWallpaper = wallpapers[indexPath.item].image
    previewView.wallImageView.image = newWallpaper
    
    reactor.provider.userDefaultService.setWallImage("w"+"\(indexPath.item)")
    
    collectionView.reloadData()
    
  }
}
