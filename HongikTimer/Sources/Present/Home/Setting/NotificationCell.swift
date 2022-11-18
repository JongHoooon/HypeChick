//
//  NotificationCell.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit

final class NotificationCell: UICollectionViewCell {
        
    var notification: Notification? {
        didSet { setupView() }
    }
    
    private lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 48.0 / 2
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray6
    }
    // TODO: 사진 크기 맞게 조절하기
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .bold)
        $0.numberOfLines = 1
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0, weight: .medium)
        $0.numberOfLines = 2
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10.0, weight: .medium)
        $0.textColor = .secondaryLabel
    }
    
    private lazy var separatorView = UIView().then {
        $0.backgroundColor = .separator
        $0.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setupView()
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            dateLabel
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 4.0
        }
        
        [
            iconImageView,
            stackView,
            separatorView
        ].forEach { addSubview($0) }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview().inset(16.0)
            $0.width.height.equalTo(48.0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(iconImageView).offset(-4.0)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(8.0)
            $0.bottom.greaterThanOrEqualToSuperview().inset(16.0)
        }
        
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setupView() {
        iconImageView.image = notification?.iconImage
        titleLabel.text = notification?.title
        descriptionLabel.text = notification?.description
        dateLabel.text = notification?.date
    }
}
