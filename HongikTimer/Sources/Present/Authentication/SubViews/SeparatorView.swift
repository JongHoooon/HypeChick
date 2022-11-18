//
//  SeparatorView.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/16.
//

import Then
import SnapKit
import UIKit

final class SeparatorView: UIView {
    
    private lazy var leftSeparator = UIView().then {
        $0.backgroundColor = .separator
    }
    
    private lazy var rightSeparator = UIView().then {
        $0.backgroundColor = .separator
    }
    
    private lazy var textLabel = UILabel().then {
        $0.text = "또는"
        $0.textColor = .separator
        $0.font = .systemFont(ofSize: 12.0, weight: .light)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        [
            leftSeparator,
            textLabel,
            rightSeparator
        ].forEach { addSubview($0) }
        
        leftSeparator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(textLabel.snp.leading).offset(-4.0)
            $0.height.equalTo(0.5)
            $0.centerY.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightSeparator.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(textLabel.snp.trailing).offset(4.0)
            $0.height.equalTo(0.5)
            $0.centerY.equalToSuperview()
        }
    }
}
