//
//  SettingViewController.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/13.
//

import Firebase
import SnapKit
import Then
import NaverThirdPartyLogin
import KakaoSDKAuth
import UIKit

final class SettingViewController: UIViewController {
  
  private lazy var tableView = UITableView().then {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    $0.dataSource = self
    $0.delegate = self
  }
  
  private lazy var settings = [[SettingCellModel]]()
  
  // MARK: - Lifecycle
  
  private lazy var naverAuthService = NaverAuthService(delegate: self)
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    setNavigationBar()
    configureModels()
    setLayout()
  }
}

// MARK: - TableView

extension SettingViewController: UITableViewDataSource {
  func numberOfSections(
    in tableView: UITableView
  ) -> Int {
    print("DEBUG print seetings sction's count is \(settings.count)")
    return settings.count
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return settings[section].count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = settings[indexPath.section][indexPath.row].title
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.textColor = .red
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(
      at: indexPath,
      animated: true
    )
    settings[indexPath.section][indexPath.row].handler()
  }
}

extension SettingViewController: UITableViewDelegate {
  
}

// MARK: - NaverThirdPartyLoginConnectionDelegate

extension SettingViewController: NaverThirdPartyLoginConnectionDelegate {
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("DEBUG 네이버 로그인 성공")
  }
  
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    //        print("DEBUG 네이버 토큰\(shared?.accessToken)")
  }
  
  func oauth20ConnectionDidFinishDeleteToken() {
    print("DEBUG setting 화면에서 네이버 로그아웃")
  }
  
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("DEBUG 에러 = \(error.localizedDescription)")
  }
}

// MARK: - Private

private extension SettingViewController {
  func setNavigationBar() {
    navigationController?.navigationBar.topItem?.title = ""
  }
  
  func setLayout() {
    view.backgroundColor = .systemBackground
    
    [
      tableView
    ].forEach { view.addSubview($0) }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    print("set layout")
  }
  
  func configureModels() {
    let section = [
      SettingCellModel(title: "로그아웃", handler: tapLogOut)
    ]
    settings.append(section)
    tableView.reloadData()
    
    print(settings)
  }
  
  func tapLogOut() {
    
    let actionSheet = UIAlertController(
      title: "Log Out",
      message: "로그아웃 하시겠습니까?",
      preferredStyle: .actionSheet
    ).then {
      $0.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      $0.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { [weak self] _ in
        AuthService.shared.logOutWithFirebase { success in
          DispatchQueue.main.async {
            if success {
              
              print("DEBUG 로그아웃 시도")
              
              try? Auth.auth().signOut()
              ServiceProvider().userDefaultService.logoutUser()
              
              let vc = RegisterViewController(with: RegisterViewReactor(ServiceProvider()))
              let nv = UINavigationController(rootViewController: vc)
              nv.modalPresentationStyle = .fullScreen
              self?.present(nv, animated: true) { [weak self] in
                self?.navigationController?.popToRootViewController(animated: false)
                self?.tabBarController?.selectedIndex = 0
              }
            } else {
              fatalError("Could not log out user")
            }
          }
        }
      }))
    }
    
    actionSheet.popoverPresentationController?.sourceView = tableView
    actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
    present(actionSheet, animated: true)
    
    naverAuthService.shared?.requestDeleteToken()
    
    let vc = RegisterViewController(with: RegisterViewReactor(ServiceProvider()))
    let nv = UINavigationController(rootViewController: vc)
    nv.modalPresentationStyle = .fullScreen
    present(nv, animated: true) { [weak self] in
      self?.navigationController?.popToRootViewController(animated: false)
      self?.tabBarController?.selectedIndex = 0
    }
  }
}
