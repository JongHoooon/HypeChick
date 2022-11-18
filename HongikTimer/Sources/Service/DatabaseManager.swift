//
//  DatabaseManager.swift
//  HongikTimer
//
//  Created by JongHoon on 2022/09/18.
//

import Foundation
import Firebase

final class DatabaseManager: NSObject {
  
  static let shared = DatabaseManager()
  
  private let database = Database.database()
  
  /// Check if email is available
  /// - Parameters
  ///   - email: String representing email
  func canCreateNewUser(with email: String, completion: (Bool) -> Void) {
    
  }
  
  /// insert new data to database
  func insertNewUser(with email: String, username: String) {
    //        database
  }
}
