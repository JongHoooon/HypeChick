//
//  TodoSettingViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/10/12.
//

import UIKit

final class TodoSettingViewController: UIViewController {
    
    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
    }
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - TableView

extension TodoSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TodoSettingViewController: UITableViewDelegate {
    
}

// MARK: - Private
private extension TodoSettingViewController {
    
}

// TODO: 시간 알림설정, 목록 추가
