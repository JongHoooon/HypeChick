//
//  PurposeView.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit

final class PurposeView: UIView {
        
    private var purpose: String? 
//    private lazy var purposeImageView = UIImageView().then {
//        $0.image = UIImage(named: "speechBubble")
//        $0.contentMode = .scaleToFill
//    }
    
    lazy var purposeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = purpose
    }
    
    // MARK: - Lifecycle
    
    init(purpose: String) {
        self.purpose = purpose
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPurpose(with purpose: String) {
        purposeLabel.text = purpose
    }
}

// MARK: - Private

private extension PurposeView {
    func setLayout() {
        [
//            purposeImageView,
            purposeLabel
        ].forEach { addSubview($0) }
        
//        purposeImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.height.equalTo(frame.height)
//            $0.width.equalTo(frame.width)
//        }
        
        purposeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(32.0)
            $0.centerX.equalToSuperview()
        }
    }
}
