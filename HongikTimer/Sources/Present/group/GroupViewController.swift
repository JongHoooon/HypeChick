//
//  GroupViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit

final class GroupViewController: UIViewController {
  
  // MARK: - Property

  private lazy var groupCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = UICollectionViewFlowLayout()
        
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
        
    $0.dataSource = self
    $0.delegate = self
    
    $0.register(
      GroupViewCell.self,
      forCellWithReuseIdentifier: GroupViewCell.identifier
    )
    
    $0.backgroundColor = .systemGray6
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    configureNavigationBar()
  }
  
  // MARK: - init

}

// MARK: - Metod
 
private extension GroupViewController {
  func configureNavigationBar() {
    navigationItem.title = "Group"
  }
  
  func configureLayout() {
    view.backgroundColor = .systemBackground
    
    [
      groupCollectionView
    ].forEach { view.addSubview($0) }
  
    groupCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension GroupViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    3
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GroupViewCell.identifier,
      for: indexPath
    ) as? GroupViewCell
    
    cell?.layer.cornerRadius = 8.0
    cell?.clipsToBounds = true
    
    return cell ?? UICollectionViewCell()
  }
  
}

extension GroupViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 8.0, height: 100)
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
}
