//
//  Notification.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import UIKit

enum NotificationIcon {
    case pencil
    case person
}

struct Notification {
    private let icon: NotificationIcon
    let title: String
    let description: String
    let date: String
    var iconImage: UIImage? {
        switch icon {
        case .pencil: return UIImage(systemName: "pencil")
        case .person: return UIImage(systemName: "text.bubble")
        }
    }
    
    init(icon: NotificationIcon, title: String, description: String, date: String) {
        self.icon = icon
        self.title = title
        self.description = description
        self.date = date
    }
}
