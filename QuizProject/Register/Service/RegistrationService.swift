//
//  RegistrationService.swift
//  QuizProject
//
//  Created by Martin Dinev on 20.01.22.
//

import Combine
import Foundation
import Firebase

class RegistrationService{
    func register(emaill: String, pass: String, usrname: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future {
                promise in
                
                Auth.auth()
                    .createUser(withEmail: emaill, password: pass) {
                        res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                let format = DateFormatter()
                                format.dateFormat = "MM-dd-yyyy"
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .updateChildValues(["username": usrname,
                                                        "points": 0,
                                                        "last_day_played" : format.string(from: Date()),
                                                        "played_games": 0]) { error, ref in
                                        if let err = error {
                                            promise(.failure(err))
                                        } else {
                                            promise(.success(()))
                                        }
                                    }
                            } else {
                                promise(.failure(NSError(domain: "Invalid user", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func isUserExist(uid: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future {
                promise in
                
                Database.database().reference()
                    .child("users")
                    .child("uid")
                    .observe(.value) { snapshot in
                        if (snapshot.value == nil) {
                            promise(.success(false))
                        }
                        promise(.success(true))
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
