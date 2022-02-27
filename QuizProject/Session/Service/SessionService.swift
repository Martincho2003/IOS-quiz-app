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
import Firebase

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
    
    var statep = PassthroughSubject<SessionState, Never>()
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func setupFirebaseAuthHandler(){
        handler = Auth
            .auth()
            .addStateDidChangeListener({ res, user in
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.refreshDetails(with: uid)
                }
                self.statep.send(self.state)
            })
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
