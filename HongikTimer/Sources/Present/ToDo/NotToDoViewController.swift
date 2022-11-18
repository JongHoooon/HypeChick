//
//  NotToDoViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/27.
//

/*

import SnapKit
import Then
import UIKit

final class NotToDoViewController: UIViewController {
    
    private var taskListVM = TaskListViewModel()
    private var editIndexPath: IndexPath = []
    
    private lazy var weekView = WeekView()
    private lazy var taskView = TaskCollectionView(taskListVM).then {
        $0.presentTaskEditViewCompletion = { [weak self] taskVM, indexPath in
            self?.editIndexPath = indexPath
            let vc = TaskEditViewController(
                taskVM,
                indexPath: indexPath
            )
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self?.present(vc, animated: true)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
}

// MARK: - ViewControllerTransitioning
extension NotToDoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        TaskEditPresentaionController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

// MARK: - Private

private extension NotToDoViewController {
    func setupNavigationBar() {
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(moveToTodoSettingVC)
        )
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupLayout() {
        view.backgroundColor = .systemBackground
        [
            weekView,
            taskView
        ].forEach { view.addSubview($0) }
        
        weekView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64.0)
        }
        
        taskView.snp.makeConstraints {
            $0.top.equalTo(weekView.snp.bottom).offset(16.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
// MARK: - Selector
    @objc func moveToTodoSettingVC() {
        let vc = TodoSettingViewController()
        navigationController?.pushViewController(
            vc,
            animated: true
        )
    }
}

*/
