//
//  NilGroupViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/23.
//

import UIKit
import SnapKit
import Then

final class NilGroupViewController: UIViewController {
  
  lazy var nilImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "noGroup")
  }
  
  private lazy var bubbleImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(named: "noGroupBubble")
  }
  
  private lazy var nilLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 36.0)
    $0.textColor = .label
    $0.numberOfLines = 0
//    $0.text = "가입한 그룹이 없습니다!"
    $0.textAlignment = .center
  }
  
  private lazy var clearBarButton = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if UserDefaultService.shared.getUser()?.userInfo.clubID != nil {
      self.navigationController?.popViewController(animated: true)
    } else {
      print("DEBUG 가입한 그룹이 없습니다")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = clearBarButton
    
    self.view.backgroundColor = .systemBackground
    
    [
      nilImageView,
      bubbleImageView,
      nilLabel
    ].forEach { view.addSubview($0) }
    
    let width = self.view.frame.width
    
    nilImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.width.equalTo(width)
      $0.bottom.equalToSuperview().inset(width / 4)
    }
    
    bubbleImageView.snp.makeConstraints {
      $0.bottom.equalTo(nilImageView.snp.top).offset(width / 3)
      $0.leading.trailing.equalToSuperview().inset(32.0)
      $0.height.equalTo(width / 3)
    }
    
    nilLabel.snp.makeConstraints {
      $0.centerY.equalTo(bubbleImageView.snp.centerY)
      $0.leading.trailing.equalTo(bubbleImageView).offset(16.0)
    }
  }
}
