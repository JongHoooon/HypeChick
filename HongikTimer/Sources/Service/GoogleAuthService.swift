//
//  GoogleAuthService.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/17.
//

import UIKit
import Firebase
import GoogleSignIn

struct GoogleAuthService {
  
  static let shared = GoogleAuthService()
  
  func signInWithGoogle(with viewController: UIViewController) {
    let viewController = viewController
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
      if let error = error {
        print("ERROR", error.localizedDescription)
        return
      }
      
      guard let authentication = user?.authentication,
            let idToken = authentication.idToken else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                     accessToken: authentication.accessToken)
      
      Auth.auth().signIn(with: credential) { authDataResult, error in
        if error != nil {
          print("DEBUG google 로그인 error")
        } else {
          print("DEBUG Google 로그인 uid: \(authDataResult?.user.uid ?? "")")
          AuthNotificationManager.shared.postNotificationSignInSuccess()
        }
      }
    }
  }
}
