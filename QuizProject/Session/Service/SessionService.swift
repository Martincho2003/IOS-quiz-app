//
//  SessionService.swift
//  QuizProject
//
//  Created by Martin Dinev on 30.01.22.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        handler = Auth
            .auth()
            .addStateDidChangeListener({ res, user in
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.refreshDetails(with: uid)
                }
            })
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func refreshDetails(with uid: String){
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .observe(.value) { user in
                let value = user.value as? NSDictionary
                let username = value?["username"] as? String
                let points = value?["points"] as? Int
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(username: username ?? "N/A", points: points ?? -1)
                }
            }
    }
    
}
