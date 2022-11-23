//
//  GroupCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/11/02.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
 
enum Level: String {
  case basic = "BASIC"
  case silver = "SILVER"
  case gold = "GOLD"
  
  var image: UIImage? {
    switch self {
    case .basic: return UIImage(named: "chick1")
    case .silver: return UIImage(named: "chick2")
    case .gold: return UIImage(named: "chick3")
    }
  }
}

final class GroupCell: UICollectionViewCell, View {
  
  var disposeBag = DisposeBag()
  
  lazy var memberImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "smallChick")
  }
  
  private lazy var memberNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.text = "김홍익"
  }
  
  private lazy var memberTimeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.text = "00:00:00"
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    configureUI()
  
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: GroupCellReactor) {
    
    // state
    reactor.state.asObservable().map { $0.member }
      .subscribe(onNext: { [weak self] member in
        guard let self = self else { return }
        
        let image = Level(rawValue: member.level ?? "BASIC")?.image
        self.memberImageView.image = image
        
        self.memberNameLabel.text = member.username
        
        let sec = member.studyTime ?? 0
        let time = sec
        let hour = time / 3600
        let miniute = (time % 3600) / 60
        let second = (time % 3600) % 60
        
        self.memberTimeLabel.text = String(
          format: "%02d:%02d:%02d",
          hour,
          miniute,
          second
        )
      })
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Method

extension GroupCell {
  
  func configureCell(_ testGroup: TestGroup) {
    self.memberImageView.image = UIImage(named: testGroup.imageName)
    self.memberNameLabel.text = testGroup.name
    self.memberTimeLabel.text = testGroup.time
  }
  
  private func configureUI() {
    
    backgroundColor = .systemBackground
    
    [
      memberImageView,
      memberNameLabel,
      memberTimeLabel
    ].forEach { addSubview($0) }
  
    memberImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16.0)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(88.0)
    }
    
    memberNameLabel.snp.makeConstraints {
      $0.top.equalTo(memberImageView.snp.bottom).offset(8.0)
      $0.centerX.equalToSuperview()
    }
    
    memberTimeLabel.snp.makeConstraints {
      $0.top.equalTo(memberNameLabel.snp.bottom).offset(4.0)
      $0.centerX.equalToSuperview()
    }
  }
}
