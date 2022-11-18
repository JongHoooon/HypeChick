//
//  GroupDetailViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import Foundation
import UIKit
import CoreAudioTypes

final class GroupDetailViewController: UIViewController {
  
  // MARK: - Property
  
  var dummy: [TestGroup] = [
    TestGroup(name: "김홍익", imageName: "chick1", time: "01:04:36"),
    TestGroup(name: "박와우", imageName: "chick2", time: "00:01:01"),
    TestGroup(name: "정마포", imageName: "chick0", time: "00:37:13"),
    TestGroup(name: "이합정", imageName: "chick1", time: "00:53:28")
  ]
  
  // MARK: - UI
  
  private lazy var titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20.0, weight: .bold)
    $0.textAlignment = .center
    $0.text = "취업준비 스터디"
    $0.textColor = .label
    $0.numberOfLines = 1
  }
  
  private lazy var purposePresentButton = UIButton().then {
    $0.backgroundColor = UIColor.init(rgb: 0xDBF0FF)
    $0.setTitleColor(.label, for: .normal)
    $0.titleLabel?.numberOfLines = 1
    
#warning("더미")
    $0.setTitle("🔥 열심히 하자!! 🔥", for: .normal)
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
    
    $0.dataSource = self
    $0.delegate = self
    
    $0.register(
      GroupDetailCell.self,
      forCellWithReuseIdentifier: GroupDetailCell.identifier
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
    
    totalTimeLabel.text = "00:01:33"
    
  }
  
  // MARK: - init
  
}

// MARK: - CollectionView

extension GroupDetailViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return dummy.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GroupDetailCell.identifier, for: indexPath
    ) as? GroupDetailCell
    
    let dummy = dummy[indexPath.item]
    cell?.configureCell(dummy)
    
    return cell ?? UICollectionViewCell()
  }
}

extension GroupDetailViewController: UICollectionViewDelegateFlowLayout {
  
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
    return UIEdgeInsets(top: 4.0, left: 32.0, bottom: 4.0, right: 32.0)
  }
}

// MARK: - Metod

private extension GroupDetailViewController {
  func configureNavigationBar() {
    navigationItem.title = "Group"
  }
  
  func configureLayout() {
    
    view.backgroundColor = .systemBackground
    
    [
      titleLabel,
      purposePresentButton,
      groupDetailCollectionView,
      todayLabel,
      totalTimeLabel
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
    }
    
    purposePresentButton.snp.makeConstraints {
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
      $0.top.equalTo(purposePresentButton.snp.bottom).offset(32.0)
      $0.centerX.equalToSuperview()
    }
    
    totalTimeLabel.snp.makeConstraints {
      $0.top.equalTo(todayLabel.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }
}
