//
//  AlarmViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import SnapKit
import Then
import UIKit

final class NotificationViewController: UICollectionViewController {
    
    var notifications: [Notification] = [
            Notification(
                icon: .person,
                title: "iOS 스터디",
                description: "iOS 스터디 모집합니다~",
                date: "09/31 10:34"
            ),
            Notification(
                icon: .pencil,
                title: "Java 스터디",
                description: "인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~~인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~",
                date: "10/02 15:33"
            ),
            Notification(
                icon: .person,
                title: "iOS 스터디",
                description: "iOS 스터디 모집합니다~",
                date: "09/31 10:34"
            ),
            Notification(
                icon: .pencil,
                title: "Java 스터디",
                description: "인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~~인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~",
                date: "10/02 15:33"
            ),
            Notification(
                icon: .person,
                title: "iOS 스터디",
                description: "iOS 스터디 모집합니다~",
                date: "09/31 10:34"
            ),
            Notification(
                icon: .pencil,
                title: "Java 스터디",
                description: "인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~~인프런 인강을통해 자바스프링 공부하실 분들 모집합니다~",
                date: "10/02 15:33"
            ),
            Notification(
                icon: .person,
                title: "iOS 스터디",
                description: "iOS 스터디 모집합니다~",
                date: "09/31 10:34"
            )
        ]

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationbar()
        setCollectionView()
    }
}

// MARK: - ColloectionView

extension NotificationViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return notifications.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UICollectionViewCell()
        }
        let notification = notifications[indexPath.item]
        cell.notification = notification
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return CGSize(width: view.frame.width, height: 80.0)
    }
}

// MARK: - Private

private extension NotificationViewController {
    
    func setNavigationbar() {
        navigationItem.title = "알림"
        navigationController?.navigationBar.topItem?.title = ""
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setup() {
        collectionView.register(
            NotificationCell.self,
            forCellWithReuseIdentifier: NotificationCell.identifier
        )
    }
    
    func setCollectionView() {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.estimated(view.frame.width),
            heightDimension: NSCollectionLayoutDimension.estimated(100.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 1)
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        collectionView.register(
            NotificationCell.self,
            forCellWithReuseIdentifier: NotificationCell.identifier
        )

    }

}
